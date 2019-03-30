defmodule Simpoll.Endpoint do
  use Plug.Router
  use Plug.ErrorHandler
  alias Simpoll.PollHandler

  plug Plug.Logger
  plug :match
  # Using Poison for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  plug Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison
  # responsible for dispatching responses
  plug :dispatch

  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

  post "/poll" do
    response = conn.params
    |> PollHandler.create
    |> Poison.encode!

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end

  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end
end
