FROM erlang:26.0.2-slim

ENV LANG=C.UTF-8
ENV MIX_ENV=dev

# 必要ツール（git, ca-certificates, curl, unzip）
RUN apt-get update \
 && apt-get install -y --no-install-recommends git ca-certificates curl unzip \
 && rm -rf /var/lib/apt/lists/*

# Elixir 1.17.3 (OTP 26) を導入
ENV ELIXIR_VERSION=1.17.3
RUN curl -fsSL -o /tmp/elixir.zip https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/elixir-otp-26.zip \
 && mkdir -p /usr/local/elixir \
 && unzip -q /tmp/elixir.zip -d /usr/local/elixir \
 && rm /tmp/elixir.zip \
 && ln -s /usr/local/elixir/bin/elixir /usr/local/bin/elixir \
 && ln -s /usr/local/elixir/bin/elixirc /usr/local/bin/elixirc \
 && ln -s /usr/local/elixir/bin/iex /usr/local/bin/iex \
 && ln -s /usr/local/elixir/bin/mix /usr/local/bin/mix

# Phoenix用ツール（Hex/Rebar/Phoenix Installer）
RUN mix local.hex --force \
 && mix local.rebar --force \
 && mix archive.install --force hex phx_new

WORKDIR /app

EXPOSE 4000
