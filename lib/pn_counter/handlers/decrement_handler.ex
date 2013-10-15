defmodule PnCounter.Handlers.DecrementHandler do

  def init(_transport, req, [pid_counter]) do
    {:ok, req, pid_counter}
  end

  def handle(req, pid_counter) do
    case :cowboy_req.get(:method, req) do
      "POST" ->
        PnCounter.Counter.decrement(pid_counter)
        {:ok, req} = :cowboy_req.reply(201, [], "", req)
      _ ->
        {:ok, req} = :cowboy_req.reply(405, req)
    end
    {:ok, req, pid_counter}
  end

  def terminate(_reason, _req, _pid_counter), do: :ok

end