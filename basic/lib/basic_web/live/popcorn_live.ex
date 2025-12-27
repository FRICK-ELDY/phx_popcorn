defmodule BasicWeb.PopcornLive do
  use BasicWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="p-6 space-y-3">
        <h1 class="text-2xl font-bold">Popcorn Demo</h1>
        <p class="text-slate-600">WASM は次のブランチで配置予定です。現在はデモ枠のみ表示します。</p>
        <div id="popcorn-root" phx-hook="PopcornWasm">
          <div id="popcorn-status" class="text-sm text-slate-500">
            WASM アセット未配置です。配置後に自動でロードされます。
          </div>
        </div>
      </div>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".PopcornWasm">
        export default {
          async mounted () {
            const status = this.el.querySelector("#popcorn-status")
            try {
              // 存在チェックのみ。無ければ何もしない
              const res = await fetch("/wasm/popcorn.js", { method: "HEAD" })
              if (res.ok) {
                status && (status.textContent = "WASM を初期化可能です。次のブランチで有効化されます。")
              }
            } catch (_e) {
              // 何もしない（デモ枠のみ）
            }
          }
        }
      </script>
    </Layouts.app>
    """
  end
end

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
        <div id="popcorn-root" phx-hook="PopcornWasm" data-config={Jason.encode!(@config)}>
          <div id="popcorn-status" class="text-sm text-slate-500">
            ロード待機中…
          </div>
        </div>
      </div>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".PopcornWasm">
        export default {
          async mounted () {
            try {
              const status = this.el.querySelector("#popcorn-status")
              const cfg = this.el.dataset.config ? JSON.parse(this.el.dataset.config) : {}
              // まず存在チェック（ビルド未実施でもページは表示可能にする）
              let available = false
              try {
                const res = await fetch("/wasm/popcorn.js", { method: "HEAD" })
                available = res.ok
              } catch (_e) {}

              if (!available) {
                if (status) status.textContent = "WASM アセットが見つかりません。次のブランチで追加予定です。"
                return
              }

              if (status) status.textContent = "WASM を初期化中…"
              const { Popcorn } = await import("/wasm/popcorn.js")
              await Popcorn.init({ onStdout: console.log, ...cfg })
              if (status) status.textContent = "WASM 初期化完了。コンソールをご確認ください。"
            } catch (err) {
              console.error("Failed to init Popcorn WASM:", err)
              const status = this.el.querySelector("#popcorn-status")
              if (status) status.textContent = "WASM 初期化に失敗しました。"
            }
          }
        }
      </script>
    </Layouts.app>
    """
  end
end
