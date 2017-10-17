defmodule VpsAdmin.Cluster.Connector do
  use GenServer, restart: :transient

  alias VpsAdmin.Cluster
  alias VpsAdmin.Persistence

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_args) do
    send(self(), :startup)
    {:ok, nil}
  end

  def handle_info(:startup, nil) do
    for n <- Persistence.Node.get_other_nodes(Cluster.Node.self_id) do
      Node.connect(:"#{n.name}@#{n.ip_addr}")
    end

    {:stop, :normal, nil}
  end
end