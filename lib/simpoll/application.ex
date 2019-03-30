defmodule Simpoll.Application do
  use Application

  def start(_type, _args) do
    IO.puts("Starting with port " <> System.get_env("PORT"))

    {port, ""} = Integer.parse(System.get_env("PORT"))

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
