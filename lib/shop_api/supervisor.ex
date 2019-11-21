defmodule ShopAPI.Supervisor do
  use Supervisor

  alias ShopAPI.Projectors
  alias ShopAPI.ProcessManagers

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_arg) do
    children = [
      worker(Projectors.StoreItem, [], id: :store_item),
      worker(Projectors.CartItem, [], id: :cart_item),
      worker(ProcessManagers.TransferStock, [], id: :stock_transfer_uuid)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
