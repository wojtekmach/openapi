defmodule OpenAPI do
  def parse(opts) do
    path = Keyword.fetch!(opts, :path)
    only = opts[:only]

    map = path |> File.read!() |> Jason.decode!()

    operations =
      for {path, map} <- map["paths"],
          !only or path in only,
          {method, map} <- map do
        name =
          map["operationId"]
          |> String.replace(["/", "-"], "_")
          |> Macro.underscore()
          |> String.to_atom()

        description = map["description"]

        %{
          id: map["operationId"],
          method: String.to_atom(method),
          path: path,
          name: name,
          description: description,
          parameters: map["parameters"]
        }
      end

    %{
      operations: operations
    }
  end

  defmacro defopenapi_client(opts) do
    {path, _} = Code.eval_quoted(opts[:path])
    api = OpenAPI.parse(path: path, only: opts[:only])

    new =
      quote do
        defstruct [
          :token,
          base_url: unquote(opts[:base_url]),
          http_client: OpenAPI.HTTPClient.HTTPC
        ]

        @doc """
        Returns new client.
        """
        def new(opts) do
          client = struct!(__MODULE__, opts)
          client.http_client.init()
          client
        end
      end

    operations =
      for operation <- api.operations do
        quote do
          @operation unquote(Macro.escape(operation))
          @doc OpenAPI.operation_doc(@operation)
          def unquote(operation.name)(client, params \\ []) do
            OpenAPI.request(@operation, client, params)
          end
        end
      end

    [new] ++ operations
  end

  def request(operation, client, params) do
    url = client.base_url <> operation.path

    headers = [
      {"user-agent", "openapi"},
      {"authorization", "Bearer #{client.token}"}
    ]

    body = Jason.encode!(params || %{})
    opts = []

    with {:ok, resp} <- client.http_client.request(operation.method, url, headers, body, opts) do
      {:ok, %{resp | body: Jason.decode!(resp.body)}}
    end
  end

  def operation_doc(operation) do
    """
    #{operation.id} operation.

    #{operation.description}
    #{operation_doc_parameters(operation.parameters)}
    """
  end

  defp operation_doc_parameters([]), do: ""

  defp operation_doc_parameters(parameters) do
    """
    ## Parameters:

    #{Enum.map_join(parameters || [], "\n", &" * :#{&1["name"]}")}
    """
  end
end

defmodule OpenAPI.HTTPClient do
  @callback init() :: :ok

  @callback request(
              method :: atom(),
              url :: binary(),
              headers :: [{binary(), binary()}],
              body :: binary(),
              opts :: keyword()
            ) ::
              {:ok,
               %{
                 status: 200..599,
                 headers: [{binary(), binary()}],
                 body: binary()
               }}
              | {:error, term()}
end

defmodule OpenAPI.HTTPClient.HTTPC do
  @behaviour OpenAPI.HTTPClient

  @impl true
  def init() do
    {:ok, _} = Application.ensure_all_started(:inets)
    :ok
  end

  @impl true
  def request(method, url, headers, _body, []) do
    headers = for {k, v} <- headers, do: {String.to_charlist(k), String.to_charlist(v)}
    request = {String.to_charlist(url), headers}

    case :httpc.request(method, request, [], body_format: :binary) do
      {:ok, {{_, status, _}, headers, body}} ->
        headers = for {k, v} <- headers, do: {List.to_string(k), List.to_string(v)}
        {:ok, %{status: status, headers: headers, body: body}}
    end
  end
end
