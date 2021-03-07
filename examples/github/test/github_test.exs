defmodule GitHubTest do
  use ExUnit.Case, async: true

  test "it works" do
    assert {:users_get_authenticated, 2} in GitHub.__info__(:functions)
  end
end

defmodule GitHubIntegrationTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  test "it works" do
    token = System.fetch_env!("GITHUB_TOKEN")

    client = GitHub.new(token: token)
    {:ok, response} = GitHub.users_get_authenticated(client)
    assert response.body["login"]
  end
end
