defmodule Simpoll.PollHandlerTest do
  use ExUnit.Case, async: true
  alias Simpoll.PollHandler

  test "it adds buttons" do
    
  end

  test "it adds options" do
    
  end

  test "it adds question" do
    response = PollHandler.add_question(%{somePayload: true}, "Is this a question?")
    [head | _] = response

    assert head.text == %{type: "mrkdwn", text: "Is this a question?    `0`"}
  end
end
