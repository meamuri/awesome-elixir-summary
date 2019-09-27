defmodule AwesomeTable.LibrariesAggregator do

    @helper_field :latest_category
    @stars_field "stargazers_count"

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

    def add_stars(category) do

        record_mapper = fn r ->
            url = "https://api.github.com/repos/#{r.user}/#{r.repo}"            
            {status, response} = HTTPoison.get(url) 
            stars = response.body
            |> Poison.decode!
            |> Map.get(@stars_field)
            put_in(r, [:stars], stars)
        end

        category
        |> Enum.map(record_mapper)
    end

    def test do
        aggregate
        |> Map.values()
        |> Enum.map(&(add_stars(&1)))
    end

    defp to_struct(awesome_row) do
        [one | _] = awesome_row
            |> String.replace("* ", "")
            |> String.split(") - ")
        
        [name | [link]] = one
            |> String.replace("[", "")
            |> String.replace(")", "")
            |> String.split("](")
        
        res = %{name: name, link: link}
        
        [repo_name | [ username ]] = link
            |> String.split("/")
            |> Enum.take(-2)
        
        res = put_in(res, [:user], username)
        res = put_in(res, [:repo], repo_name)
        res
    end
end
