### Popcorn Demo README

このディレクトリは、Popcorn で Elixir（AtomVM／WASM）をビルドし、Phoenix アプリ（`basic`）から利用するための最小プロジェクトです。ビルド成果物は `../basic/priv/static/wasm/` に出力され、`/popcorn` ページで読み込まれます。

- 公式ドキュメント: `https://hexdocs.pm/popcorn/readme.html`


### 前提

- Elixir 1.17.3（OTP 26.0.2）
- もしくは本リポジトリの Docker Compose 環境（Phoenix コンテナ）を使用


### ビルド（推奨: コンテナ内）

Docker Compose で Phoenix コンテナを起動した状態で、次を実行します（初回のみ依存取得します）。

```bash
docker compose exec -T app bash -lc 'cd ../popcorn_demo && mix deps.get && mix popcorn.cook'
```

成功すると、以下が生成されます（例）:

- `../basic/priv/static/wasm/popcorn.js`
- `../basic/priv/static/wasm/AtomVM.wasm`
- `../basic/priv/static/wasm/bundle.avm`


### ビルド（ローカル）

ローカルに Elixir 1.17.3（OTP 26.0.2）がある場合:

```bash
cd popcorn_demo
mix deps.get
mix popcorn.cook
```


### Phoenix 側での確認

- ブラウザで `http://localhost:4000/popcorn` を開きます。
- WASM が配置済みなら、ページ内の出力欄（Popcorn Demo）に実行結果が表示されます（「Hello from WASM!」など）。


### 関数の追加方法（Elixir 側）

1) 任意のモジュールを追加します（例: `lib/popcorn_demo/my_greeter.ex`）。

```elixir
defmodule PopcornDemo.MyGreeter do
  def greet, do: "Hello from WASM!"
end
```

2) 既存の `PopcornDemo.Worker` から呼び出します（`lib/popcorn_demo/worker.ex`）。

```elixir
defmodule PopcornDemo.Worker do
  use GenServer
  @process_name :main

  def start_link(args), do: GenServer.start_link(__MODULE__, args, name: @process_name)

  @impl true
  def init(_init_arg) do
    Popcorn.Wasm.register(@process_name)
    IO.puts(PopcornDemo.MyGreeter.greet())
    {:ok, %{}}
  end
end
```

3) 再ビルドします。

```bash
# コンテナ内
docker compose exec -T app bash -lc 'cd ../popcorn_demo && mix popcorn.cook'
```

ページをリロードすると、追加した関数の結果がページ内に表示されます。

### 参考

- Popcorn README: `https://hexdocs.pm/popcorn/readme.html`


