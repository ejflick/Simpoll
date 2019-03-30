defmodule Simpoll.Application do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Simpoll.Endpoint,
        options: [port: Application.get_env(:simpoll, :port)]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Simpoll.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
