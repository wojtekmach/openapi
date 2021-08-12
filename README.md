# OpenAPI

A proof-of-concept for generating [OpenAPI](https://www.openapis.org) clients in Elixir.

```
$ git clone --recursive git@github.com:wojtekmach/openapi.git
```

## GitHub example:

```
$ (cd openapi/examples/github && mix deps.get && iex -S mix)
```

```elixir
iex> client = GitHub.new(token: System.fetch_env!("GITHUB_TOKEN"))
iex> GitHub.users_get_authenticated(client)
{:ok, %{status: 200, body: %{"login" => "alice", ...}, ...}}
```

See [`examples/github/lib/github.ex`](examples/github/lib/github.ex)

## Stripe example:

```
$ (cd openapi/examples/stripe && mix deps.get && iex -S mix)
```

```elixir
iex> client = Stripe.new(token: System.fetch_env!("STRIPE_TOKEN"))
iex> Stripe.get_account(client)
{:ok, %{status: 200, body: %{"display_name" => "ACME, Inc", ...}, ...}}
```

See [`examples/stripe/lib/stripe.ex`](examples/stripe/lib/stripe.ex)

## License

Copyright 2021 Wojtek Mach

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
