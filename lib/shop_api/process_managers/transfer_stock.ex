defmodule ShopAPI.ProcessManagers.TransferStock do
  require Logger
  alias __MODULE__
  alias ShopAPI.Events.{AddCartItemRequested, AddedToCart, PulledFromStoreStock}
  alias ShopAPI.Commands.{AddToCart, PullFromStoreStock}

  use Commanded.ProcessManagers.ProcessManager,
    name: "ProcessManagers.TransferStock",
    router: ShopAPI.Router

  @derive Jason.Encoder
  defstruct([
    :stock_transfer_uuid,
    :cart_item_uuid,
    :store_item_uuid,
    :quantity_requested,
    :status
  ])

  def interested?(%AddCartItemRequested{stock_transfer_uuid: nil}), do: false

  def interested?(%AddCartItemRequested{stock_transfer_uuid: stock_transfer_uuid}) do
    {:start!, stock_transfer_uuid}
  end

  def interested?(%PulledFromStoreStock{stock_transfer_uuid: nil}), do: false

  def interested?(%PulledFromStoreStock{
        stock_transfer_uuid: stock_transfer_uuid
      }),
      do: {:continue!, stock_transfer_uuid}

  def interested?(%AddedToCart{stock_transfer_uuid: nil}) do
    false
  end

  def interested?(%AddedToCart{stock_transfer_uuid: stock_transfer_uuid}) do
    {:stop, stock_transfer_uuid}
  end

  def interested?(_), do: false

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

  def handle(
        %TransferStock{
          cart_item_uuid: cart_item_uuid,
          stock_transfer_uuid: stock_transfer_uuid,
          quantity_requested: quantity_requested
        },
        %PulledFromStoreStock{
          stock_transfer_uuid: stock_transfer_uuid,
          store_item_uuid: store_item_uuid
        }
      ) do
    %AddToCart{
      stock_transfer_uuid: stock_transfer_uuid,
      quantity_requested: quantity_requested,
      store_item_uuid: store_item_uuid,
      cart_item_uuid: cart_item_uuid
    }
  end

  def apply(%TransferStock{} = pm, %AddCartItemRequested{} = evt) do
    %TransferStock{
      pm
      | stock_transfer_uuid: evt.stock_transfer_uuid,
        cart_item_uuid: evt.cart_item_uuid,
        store_item_uuid: evt.store_item_uuid,
        quantity_requested: evt.quantity_requested,
        status: :pull_from_store_stock
    }
  end

  def apply(%TransferStock{} = pm, %PulledFromStoreStock{}) do
    %TransferStock{
      pm
      | status: :add_to_cart
    }
  end

  def error(error, _command_or_event, _failure_context) do
    Logger.error(fn -> "#{__MODULE__} encountered an error: " <> inspect(error) end)
    {:skip, error}
  end
end
