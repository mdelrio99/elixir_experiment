defmodule CPU do
#use GenServer

  def init(init_arg) do
    {:ok, init_arg}
  end

#  def child_spec(opts) do
#    %{
##      id: __MODULE__,
 #     start: {__MODULE__, :start_link, [opts]},
 #     type: :worker,
 #     restart: :permanent,
 #     shutdown: 500
 #   }
 # end

  def start_link(opts) do
##      internal_start([])
    {Kernel.self, :ok, opts}
  end


  def internal_start(initial) do
    process = spawn_link(fn -> execute(initial) end)
    Process.register(process, Storage)


    spawn( &CPU.periodicCheck/0)
    Phoenix.PubSub.subscribe(Exper.PubSub, "cpu_usage")

    process
  end


  def execute(state) do
    receive do
      {:get, sender} ->
        send(sender, state)
        execute(state)
      {:put, val} ->
#        execute(state ++ [val])
        execute(val)
    end
  end

  def put(value) do
    send(Storage, {:put, value})
  end

  def get do
    send(Storage, {:get, self()})
    receive do
      msg -> msg
    end
  end

  def callOSForCPU() do
    cpuVal = String.trim(List.to_string(:os.cmd('/home/mike/getcpu')))
    put(cpuVal)

    cpuVal
  end

  def getCPU() do
    get()
  end


  def periodicCheck() do
    Process.sleep(250)

    cpuVal = callOSForCPU()

#    Phoenix.PubSub.broadcast("cpu_usage", cpuVal)

    periodicCheck()
  end




end
