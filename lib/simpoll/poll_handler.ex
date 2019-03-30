defmodule Simpoll.PollHandler do
  def create(%{"text" => _text}) do
    #%{text: "hi"}
    error_response
  end

  def create(_) do
    error_response
  end

  def error_response do
    %{text: "Error interpretting request"}
  end
end
