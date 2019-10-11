defmodule AwesomeTable.Libraries.Aggregator do

    @helper_field :latest_category

    def aggregate do
        url = "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"
        description_row_filter = fn row -> 
            !(String.starts_with?(row, "*") and String.ends_with?(row, "*"))
        end

        with {:ok, response} = HTTPoison.get(url) do
            response.body
                |> String.split("\n")
                |> Enum.drop_while(&(!String.starts_with?(&1, "##")))
                |> Enum.filter(&(&1 != "" and &1 != "\n"))
                |> Enum.filter(description_row_filter)
                |> Enum.reduce(%{@helper_field => ""}, &aggregate_helper/2)
                |> Map.delete(@helper_field)
                |> Map.values
                |> List.flatten
        end
    end

    defp aggregate_helper(x, acc) do
        cond do
            String.starts_with?(x, "##") -> 
                with len <- String.length(x),
                    title <- String.slice(x, 3, len - 3),
                    res <- put_in(acc, [title], []),
                    output <- %{res | @helper_field => title} do
                    output
                end
            String.starts_with?(x, "* ") and String.contains?(x, "](https://github.com/") ->
                with key <- acc[@helper_field],
                    record <- to_struct(x),
                    res = put_in(record, [:category], key) do
                    %{acc | key => [ res | acc[key]]}
                end
            true -> acc
        end
    end

    def add_temp_stars(record) do
      put_in(record, [:stars], -1)
      # -1 means that api request required for getting stars
      # -2 means that api redirect required
      # -3 means that stars undefined after api redirect. Should be researched
    end

    defp to_struct(awesome_row) do
        [one | _] = awesome_row
            |> String.replace("* ", "")
            |> String.split(") - ")
        
        [name | [url]] = one
            |> String.replace("[", "")
            |> String.replace(")", "")
            |> String.split("](")
        
        res = %{name: name, url: url}
        
        [username | [ repo_name ]] = url
            |> String.split("/")
            |> Enum.take(-2)
        
        res = put_in(res, [:user], username)
        res = put_in(res, [:title], repo_name)
        res = put_in(res, [:stars], -1)
        res
    end
end
