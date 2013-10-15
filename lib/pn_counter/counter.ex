defmodule PnCounter.Counter do
  use GenServer.Behaviour

  @master_node :"counter@jurmacbookpro.local"

  # External API

  def start_link() when node() == @master_node do
    IO.puts "Master node starting"
    start_link({0,0})
  end

  def start_link() do
    IO.puts "Slave node starting"
    IO.puts "Node: #{node()} master: #{@master_node}"
    case :net_kernel.connect_node(@master_node) do
      true ->
        start_link({0,0})
      _    ->
        IO.puts "Error connecting to master counter, check cookies, network connection and repeat"
        System.halt(1)
    end
  end


  # OTP behaviour callbacks
  #

  def start_link(initial_value) do
    result = {:ok, pid} = :gen_server.start_link( __MODULE__, initial_value, [])
    :pg2.create(:pn_counter)
    case :pg2.get_closest_pid(:pn_counter) do
      {:error, _} -> :ok
      []          -> :ok
      remote_node ->
        remote_node <- {:pn_counter_request, pid}
    end
    :pg2.join(:pn_counter, pid)
    result
  end

  def get_value(pid) do
    :gen_server.call pid, :get_value
  end

  def increment(pid) do
    :gen_server.cast pid, :increment
  end

  def decrement(pid) do
    :gen_server.cast pid, :decrement
  end


  # GenServer

  def init(current_value)  do
    { :ok, current_value }
  end

  def handle_call(:get_value, _from, {p_counter, n_counter}) do
    calculated_value = p_counter - n_counter
    { :reply, calculated_value, {p_counter, n_counter} }
  end

  def handle_cast(:increment, {p_counter, n_counter}) do
    new_value = {p_counter + 1, n_counter}
    share_new_value(new_value)
    { :noreply, new_value }
  end

  def handle_cast(:decrement, {p_counter, n_counter}) do
    new_value = {p_counter, n_counter + 1}
    share_new_value(new_value)
    { :noreply, new_value }
  end

  def handle_info({:pg_message, _from , :pn_counter_value, {rem_p, rem_n}}, {p_counter, n_counter})  do
    if rem_p > p_counter, do: p_counter = rem_p
    if rem_n > n_counter, do: n_counter = rem_n
    {:noreply, {p_counter, n_counter}}
  end

  def handle_info({:pg_message, from , :pn_counter_request}, current_value)  do
    from <- {:pn_counter_value, current_value}
    {:noreply, current_value}
  end

  defp share_new_value(value) do
    case :pg2.get_members(:pn_counter) do
      {:error, _} -> :ok
      []          -> :ok
      pids        -> share_new_value(pids -- [self()], value)
    end
  end

  defp share_new_value([], _value), do: :ok

  defp share_new_value(pids, value) do
    IO.puts "Pids: #{inspect pids}"
    pids <- {:pn_counter_value, value}
  end

end