defmodule Simpoll.EndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Simpoll.Endpoint.init([])

  test "it returns pong" do
    # Create a test connection
    conn = conn(:get, "/ping")

    # Invoke the plug
    conn = Simpoll.Endpoint.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "pong!"
  end

  test "it returns 404 when no route matches" do
    # Create a test connection
    conn = conn(:get, "/fail")

    # Invoke the plug
    conn = Simpoll.Endpoint.call(conn, @opts)

    # Assert the response
    assert conn.status == 404
  end

  test "poll handles malformatted request" do
    test_str = """
    POST /poll HTTP/1.1
    Host: 59ad648f.ngrok.io
    User-Agent: Slackbot 1.0 (+https://api.slack.com/robots)
    Accept-Encoding: gzip,deflate
    Accept: application/json,*/*
    X-Slack-Signature: v0=d3c31a422d4d0486446e74ae83403207216af98506a7216aa58b9b4bd6ace9db
    X-Slack-Request-Timestamp: 1553985856
    Content-Length: 352
    Content-Type: application/x-www-form-urlencoded
    X-Forwarded-Proto: https
    X-Forwarded-For: 54.172.14.223

    token=bG483amisFxbzXr2UC79thyY&team_id=TG2UA6YS2&team_domain=lelbot&channel_id=CG1MW2MFX&channel_name=lelbot&user_id=UG1MW27M3&user_name=flick.ej&command=%2Fpoll&text=hi+hihi&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FTG2UA6YS2%2F595771938518%2FaWOBkbwB6RNN6RxSfK9iKzqg&trigger_id=595407466775.546962236886.a971285b0641e7434f4acfaf42feff5e
    """
    conn = conn(:post, "/poll", test_str)
    conn = Simpoll.Endpoint.call(conn, @opts)
    assert conn.status == 200
    assert conn.resp_body == Poison.encode!(%{text: "Error interpretting request"})
  end

  test "poll works" do
    test_str = """
    POST /poll HTTP/1.1
    User-Agent: Slackbot 1.0 (+https://api.slack.com/robots)
    Accept-Encoding: gzip,deflate
    Accept: application/json,*/*
    X-Slack-Signature: v0=ea1ba47c166cc62e5b50b8bd8a23099360f9fc95e6e5bd09da5cd15f056405ca
    X-Slack-Request-Timestamp: 1554052647
    Content-Length: 418
    Content-Type: application/x-www-form-urlencoded
    Host: 7c9327e2.ngrok.io
    Cache-Control: max-age=259200
    X-Forwarded-For: 54.90.40.91

    token=bG483amisFxbzXr2UC79thyY&team_id=TG2UA6YS2&team_domain=lelbot&channel_id=CG1B6C7QU&channel_name=general&user_id=UG1MW27M3&user_name=flick.ej&command=%2Fpol&text=%22This+is+my+question%22+%22this+is+an+option%22+%22this+is+an+optioN%22&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FTG2UA6YS2%2F595730996327%2F18CuSfy18jJe80qqtoQ9EFVw&trigger_id=596095389910.546962236886.54e9a5f95da28c3fdd8ee4689e880dd8
    """
    conn = conn(:post, "/poll", test_str)
    conn = Simpoll.Endpoint.call(conn, @opts)
    IO.inspect conn.resp_body
    assert conn.status == 200
  end
end
