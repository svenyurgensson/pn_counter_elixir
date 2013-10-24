defmodule PnCounter.Handlers.IncrementHandler do

  def init(_transport, req, []) do
    {:ok, req, []}
  end

  def handle(req, []) do
    case :cowboy_req.get(:method, req) do
      "POST" ->
        PnCounter.Counter.increment()
        {:ok, req} = :cowboy_req.reply(201, [], "", req)
      _ ->
        {:ok, req} = :cowboy_req.reply(405, req)
    end
    {:ok, req, []}
  end

  def terminate(_reason, _req, _), do: :ok

end