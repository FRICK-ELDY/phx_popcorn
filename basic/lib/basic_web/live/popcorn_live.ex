defmodule BasicWeb.PopcornLive do
  use BasicWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, config: %{onStdout: "console"})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="p-6">
        <h1 class="text-2xl font-bold mb-2">Popcorn WASM Demo</h1>
        <p class="text-slate-600 mb-4">WASM アセットが存在する場合は、コンソールに「Hello from WASM!」が出力されます。</p>
        <div id="popcorn-root" phx-hook="PopcornWasm">
          <div id="popcorn-status" class="text-sm text-slate-500">
            ロード待機中…
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
