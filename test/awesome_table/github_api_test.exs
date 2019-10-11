defmodule AwesomeTable.GithubApiTest do
  use AwesomeTable.DataCase

  alias AwesomeTable.GithubRepositoryApi

  test "stars of current repo should be great or equals to 0" do
    response = GithubRepositoryApi.fetch_repo("/meamuri/awesome-elixir-summary")
    assert response["stargazers_count"] >= 0
  end

  test "stars of unknown repo (404 response) should be negative value (-2)" do
    response = GithubRepositoryApi.repo_stars(%{user: "aaa", title: "bbb"})
    assert response == -2
  end
end
