defmodule ShopAPI.ProcessManagers.TransferStock do
  alias __MODULE__
  alias ShopAPI.Events.AddCartItemRequested
  alias ShopAPI.Repo
  alias ShopAPI.Projections.StoreItem
  alias ShopAPI.Commands.PullFromStoreStock

  use Commanded.ProcessManagers.ProcessManager,
    name: "ProcessManagers.TransferStock",
    router: ShopAPI.Router

  @derive Jason.Encoder
  defstruct([
    :stock_transfer_uuid,
    :cart_item_uuid,
    :store_item_uuid,
    # i.e. :add or :remove
    :cart_update_type,
    :quantity,
    :status
  ])

  def interested?(%AddCartItemRequested{
        stock_transfer_uuid: stock_transfer_uuid,
        store_item_uuid: store_item_uuid,
        quantity_requested: quantity_requested
      }) do
    store_item = Repo.get(StoreItem, store_item_uuid)

    if quantity_requested <= store_item.quantity_in_stock do
      {:start!, stock_transfer_uuid}
    else
      false
    end
  end

  def handle(
        %TransferStock{},
        %AddCartItemRequested{
          stock_transfer_uuid: stock_transfer_uuid,
          quantity_requested: quantity_requested,
          store_item_uuid: store_item_uuid
        }
      ) do
    %PullFromStoreStock{
      stock_transfer_uuid: stock_transfer_uuid,
      quantity_requested: quantity_requested,
      store_item_uuid: store_item_uuid
    }
  end

  def apply(%TransferStock{} = pm, %AddCartItemRequested{} = evt) do
    %TransferStock{
      pm
      | stock_transfer_uuid: evt.stock_transfer_uuid,
        cart_item_uuid: evt.cart_item_uuid,
        store_item_uuid: evt.store_item_uuid,
        cart_update_type: :add,
        quantity: evt.quantity_requested,
        status: :pull_from_store_stock
    }
  end
end
