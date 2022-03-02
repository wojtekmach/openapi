defmodule Lob do
  import OpenAPI

  defopenapi_client(
    path: Application.app_dir(:lob, "priv/lob-api-bundled.yml"),
    base_url: "https://api.lob.com/v1",
    only: ["/us_verifications"],
    format: :yml
  )
end
