defmodule PnCounter.Supervisor do
  use Supervisor.Behaviour

  def start_link() do
    {:ok, sup} = :supervisor.start_link(__MODULE__, [])
    :supervisor.start_child(sup, worker(PnCounter.Counter, []))
  end

  def init(_) do
    supervise([], strategy: :one_for_one)
  end


end
