defmodule PnCounter.Handlers.CounterHandler do

  def init(_transport, req, []) do
    {:ok, req, []}
  end

  def handle(req, _) do
    case :cowboy_req.get(:method, req) do
      "GET" ->
        value = PnCounter.Counter.get_value()
        {:ok, req} = :cowboy_req.reply(200, [], integer_to_binary(value), req)
      _ ->
        {:ok, req} = :cowboy_req.reply(405, req)
    end
    {:ok, req, []}
  end

  def terminate(_reason, _req, _), do: :ok

end