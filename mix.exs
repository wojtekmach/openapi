defmodule OpenAPI.MixProject do
  use Mix.Project

  def project do
    [
      app: :openapi,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      xref: [
        exclude: [
          :httpc
        ]
      ],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :ssl]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.0"}
    ]
  end
end
