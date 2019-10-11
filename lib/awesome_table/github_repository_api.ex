defmodule AwesomeTable.GithubRepositoryApi do

  @github_api_url "https://api.github.com/repos"
  @stars_field "stargazers_count"
  @token Application.get_env(:awesome_table, :github_token)
  @headers ["Authorization": "token #{@token}"]

  def repo_stars(%{title: title, user: user}) do
    fetch_repo("#{title}/#{user}")
           |> Poison.decode!
           |> Map.get(@stars_field)
  end

  def fetch_repo(url) do
    {:ok, response} = HTTPoison.get(@github_api_url <> url, @headers)
    handle_response(response.status_code, response)
  end

  defp handle_response(301, response) do
    with {_, redirect} <- Enum.find(response.headers, fn {key, _} -> key == "Location" end),
         {:ok, response} <- fetch_repo(redirect) do
      response.body
    end
  end

  defp handle_response(200, response) do
    response.body
  end

  defp handle_response(_, response) do
    %{@stars_field => -2}
  end
end
