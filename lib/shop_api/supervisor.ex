defmodule ShopAPI.Supervisor do
  use Supervisor

  alias ShopAPI.Projectors

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_arg) do
    children = [
      worker(Projectors.StoreItem, [], id: :store_item)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
