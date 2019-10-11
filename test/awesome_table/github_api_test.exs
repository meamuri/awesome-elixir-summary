defmodule AwesomeTable.GithubApiTest do
  use AwesomeTable.DataCase

  alias AwesomeTable.GithubRepositoryApi

  test "stars of current repo shuold be great or equals to 0" do
    %{user: "meamuri", title: "awesome-elixir-summary"}
    response = GithubRepositoryApi.fetch_repo("/meamuri/awesome-elixir-summary")
    assert response["stargazers_count"] >= 0
  end
end
