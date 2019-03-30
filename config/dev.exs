use Mix.Config

{port, ""} = Integer.parse(System.get_env("PORT"))
config :simpoll, port: port
