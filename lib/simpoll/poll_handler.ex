defmodule Simpoll.PollHandler do

  @argument_regex ~r/\"([^"]*)\"/

  def create(%{"text" => text}) do
    [question | options] = Regex.scan(@argument_regex, text)

    buttons(options)
    |> add_options(options)
    |> add_question(question)
  end

  def create(_) do
    error_response()
  end

  def buttons(_) do
    [%{someButtons: true}]
  end

  def add_options(options) do
    [%{someOption: true}]
  end

  def add_question([] = _options, _question) do
    %{text: "Please provide options for your poll"}
  end

  def add_question(options, question) do
    [%{
        type: "section",
        text: %{
          type: "mrkdwn",
          text: question <> "    `0`"
        }
     } | options]
  end

  def error_response do
    %{text: "Error interpretting request"}
  end
end
