## 概要

Windows + WSL2 上で Docker を使い、以下のバージョンで Phoenix 開発環境を構築します。

- Erlang: 26.0.2
- Elixir: 1.17.3 (OTP 26)
- Phoenix (phx_new): 1.8.x

このリポジトリでは、`mix phx.new basic --no-ecto` で生成したアプリを `docker compose` で起動できるように構成済みです。


## 前提条件

- Windows 11/10 + WSL2 (Ubuntu 推奨)
- Docker Desktop（WSL2 連携が有効）
- WSL ディストリ上で `docker` が使えること（`docker --version` が動作）


## 構成

- `Dockerfile`
  - ベース: `erlang:26.0.2-slim`
  - Elixir 1.17.3 (OTP 26) を zip から導入
  - Hex/Rebar と `phx_new` をインストール
- `compose.yml`
  - サービス名: `app`（コンテナ名: `phoenix_basic`）
  - ボリュームでワークスペース `.` を `/app` にマウント
  - コンテナ起動時に `mix deps.get && mix phx.server` を実行
  - `working_dir: /app/basic`（`basic` が Phoenix アプリのルート）

Phoenix の開発用設定は 0.0.0.0 バインド済み。


## 初回セットアップ

1) イメージをビルド

```bash
docker compose build
```

2) Phoenix プロジェクトを生成（済みならスキップ）

このリポジトリでは既に `basic/` を生成済みです。ゼロから再生成したい場合は以下を参考にしてください（既存の `basic/` を削除してから実行）。

```bash
docker compose run --rm --no-deps -w /app app \
  bash -lc "mix phx.new basic --no-ecto --no-install --app basic --module Basic"
```

3) 起動

```bash
docker compose up -d
```

4) アクセス

ブラウザで `http://localhost:4000` を開きます。


## よく使う操作

- ログ確認

```bash
docker logs -f phoenix_basic
```

- コンテナに入る（WSL シェルから）

```bash
docker compose exec app bash
```

- 停止

```bash
docker compose down
```

- ボリュームも含めて完全停止/初期化

```bash
docker compose down -v
```

