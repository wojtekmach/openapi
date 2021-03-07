defmodule StripeTest do
  use ExUnit.Case, async: true

  test "it works" do
    assert {:get_account, 1} in Stripe.__info__(:functions)
    assert {:get_charges, 1} in Stripe.__info__(:functions)
  end
end

defmodule StripeIntegrationTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  test "it works" do
    token = System.fetch_env!("STRIPE_TOKEN")

    client = Stripe.new(token: token)
    {:ok, response} = Stripe.get_account(client)
    assert response.body["display_name"]
  end
end
