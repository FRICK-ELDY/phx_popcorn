defmodule BasicWeb.Plugs.CrossOriginIsolation do
  import Plug.Conn
  @behaviour Plug
  def init(opts), do: opts
  def call(conn, _opts) do
    conn
    |> put_resp_header("cross-origin-opener-policy", "same-origin")
    |> put_resp_header("cross-origin-embedder-policy", "require-corp")
  end
end

defmodule BasicWeb.Plugs.CrossOriginIsolation do
  @moduledoc """
  Sets COOP/COEP headers required to run WASM (Popcorn/AtomVM) in browsers.
  """
  import Plug.Conn

  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    conn
    |> put_resp_header("cross-origin-opener-policy", "same-origin")
    |> put_resp_header("cross-origin-embedder-policy", "require-corp")
  end
end
