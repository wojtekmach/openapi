defmodule GitHub do
  import OpenAPI

  defopenapi_client(
    path: Application.app_dir(:github, "priv/api.github.com.json"),
    base_url: "https://api.github.com",
    only: ["/user"]
  )
end
