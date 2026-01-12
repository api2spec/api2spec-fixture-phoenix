FROM elixir:1.15-alpine

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache build-base git

# Install hex and rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy mix files first for caching
COPY mix.exs mix.lock ./
RUN mix deps.get && mix deps.compile

# Copy source
COPY . .
RUN mix compile

EXPOSE 4000

CMD ["mix", "phx.server"]
