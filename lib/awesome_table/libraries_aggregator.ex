defmodule AwesomeTable.LibrariesAggregator do
    def aggregate do
        url = "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"            
        with {:ok, response} = HTTPoison.get(url) do
            response.body
                |> String.split("\n")
                |> Enum.drop_while(&(!String.starts_with?(&1, "##")))
                |> Enum.filter(&(&1 != ""))
        else 
            {:error, _} -> {:error, nil}
        end
    end
end