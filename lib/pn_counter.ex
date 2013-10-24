defmodule PnCounter do
  use Application.Behaviour

  def start(_type, _args) do

    {:ok, _} = PnCounter.Supervisor.start_link()

    dispatch = :cowboy_router.compile([
                { :_, [{"/counter",           PnCounter.Handlers.CounterHandler,   []},
                       {"/counter/increment", PnCounter.Handlers.IncrementHandler, []},
                       {"/counter/decrement", PnCounter.Handlers.DecrementHandler, []} ]}
               ])

    {:ok, _} = :cowboy.start_http( :http, 100, [{:port, 8000}],
                                  [{:env, [{:dispatch, dispatch}]} ])
  end

  def stop(_state) do
    :ok
  end

end
