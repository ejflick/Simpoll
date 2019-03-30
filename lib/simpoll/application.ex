defmodule Simpoll.Application do
  use Application
  use Mix.Config

  def start(_type, _args) do
    port = Application.get_env(:simpoll, :port)
    IO.puts("Running in #{Mix.env()}")
    IO.puts("Starting with port " <> Integer.to_string(port))

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Simpoll.Endpoint,
        options: [port: port]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Simpoll.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
