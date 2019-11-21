defmodule ShopAPI.Middleware do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline

  def before_dispatch(%Pipeline{command: command} = pipeline) do
    case command.__struct__.valid?(command) do
      :ok ->
        pipeline

      {:error, msg} ->
        pipeline
        |> Pipeline.respond({:error, :command_validation_failure, command, msg})
        |> Pipeline.halt()
    end
  end

  def after_dispatch(pipeline), do: pipeline
  def after_failure(pipeline), do: pipeline
end
