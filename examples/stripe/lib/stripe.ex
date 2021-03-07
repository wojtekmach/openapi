defmodule Stripe do
  import OpenAPI

  defopenapi_client(
    path: Application.app_dir(:stripe, "priv/spec3.json"),
    base_url: "https://api.stripe.com",
    only: [
      "/v1/account",
      "/v1/charges"
    ]
  )
end
