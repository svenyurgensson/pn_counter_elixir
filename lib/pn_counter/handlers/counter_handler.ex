defmodule PnCounter.Handlers.CounterHandler do

  def init(_transport, req, [pid_counter]) do
    {:ok, req, pid_counter}
  end

  def handle(req, pid_counter) do
    case :cowboy_req.get(:method, req) do
      "GET" ->
        value = PnCounter.Counter.get_value(pid_counter)
        {:ok, req} = :cowboy_req.reply(200, [], integer_to_binary(value), req)
      _ ->
        {:ok, req} = :cowboy_req.reply(405, req)
    end
    {:ok, req, pid_counter}
  end

  def terminate(_reason, _req, _pid_counter), do: :ok

end