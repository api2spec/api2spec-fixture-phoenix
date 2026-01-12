defmodule Api2specFixturePhoenix.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Api2specFixturePhoenix.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: Api2specFixturePhoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
