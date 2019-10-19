defmodule AwesomeTable.GithubRepositoryApi do
  require Logger

  @github_api_url "https://api.github.com/repos"
  @stars_field "stargazers_count"
  @token Application.get_env(:awesome_table, :github_token)
  @headers ["Authorization": "token #{@token}"]

  def repo_stars(%{title: title, owner: user}) do
    fetch_repo("/#{user}/#{title}") |> Map.get(@stars_field)
  end

  def fetch_repo(url) do
    {:ok, response} = HTTPoison.get(@github_api_url <> url, @headers)
    case handle_response(response.status_code, response) do
      {:fetched, body} -> body |> Poison.decode!
      {:unknown, body} -> body
    end
  end

  defp handle_response(301, response) do
    with {_, redirect} <- Enum.find(response.headers, fn {key, _} -> key == "Location" end),
         {:ok, response} <- HTTPoison.get(redirect, @headers) do
      Logger.info "after redirect received message: #{inspect(response)}}"
      {:fetched, response.body}
    end
  end

  defp handle_response(200, response) do
    {:fetched, response.body}
  end

  defp handle_response(code, response) do
    Logger.info "Github processing #{inspect(response)}"
    {:unknown, %{@stars_field => -code}}
  end
end
