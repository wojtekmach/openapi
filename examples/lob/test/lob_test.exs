defmodule LobTest do
  use ExUnit.Case, async: true

  test "it works" do
    assert {:us_verification, 2} in Lob.__info__(:functions)
  end
end

defmodule LobIntegrationTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  test "it works" do
    address = %{
      city: "New York",
      primary_line: "129 West 81st Street",
      secondary_line: "Apt 5A",
      state: "NY",
      zip_code: "10024"
    }

    token = System.fetch_env!("LOB_TOKEN")

    client = Lob.new(token: token)
    {:ok, response} = Lob.us_verification(client, address)
    assert response.body
  end
end
