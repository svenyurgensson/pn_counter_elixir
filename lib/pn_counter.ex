defmodule PnCounter do
  use Application.Behaviour

  def start(_type, _args) do

    {:ok, counter_pid} = PnCounter.Supervisor.start_link()

    dispatch = :cowboy_router.compile([
                { :_, [{"/counter",           PnCounter.Handlers.CounterHandler,   [counter_pid]},
                       {"/counter/increment", PnCounter.Handlers.IncrementHandler, [counter_pid]},
                       {"/counter/decrement", PnCounter.Handlers.DecrementHandler, [counter_pid]} ]}
               ])

    {:ok, _} = :cowboy.start_http( :http, 100, [{:port, 8000}],
                                  [{:env, [{:dispatch, dispatch}]} ])
  end

  def stop(_state) do
    :ok
  end

end
