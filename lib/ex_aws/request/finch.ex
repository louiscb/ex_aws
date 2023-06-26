defmodule ExAws.Request.Finch do
  @behaviour ExAws.Request.HttpClient

  @moduledoc """
  Configuration for `:finch`.

  In order to use this `Finch` API client, you must start `Finch` and provide a `:name`. In
  your supervision tree:

  ```
      children = [
        {Finch, name: ExAws.Finch}
      ]
  ```

  You then need to set Finch as the Http client in your config:

  ```
      config :ex_aws,
        http_client: ExAws.Request.Finch
  ```
  """

  @receive_timeout 30_000

  def request(method, url, body \\ "", headers \\ [], _http_opts \\ []) do
    finch_name = Application.get_env(:ex_aws, :finch_name, ExAws.Finch)
    request = Finch.build(method, url, headers, body)

    case Finch.request(request, finch_name, receive_timeout: @receive_timeout) do
      {:ok, response} ->
        {:ok, %{status_code: response.status, headers: response.headers, body: response.body}}

      error ->
        {:error, %{reason: error}}
    end
  end
end
