defmodule ShopAPI.Aggregates.StoreItem do
  @moduledoc """
  The store item aggregate
  """
  alias __MODULE__
  alias ShopAPI.Commands.PullFromStoreStock
  alias ShopAPI.Events.PulledFromStoreStock

  defstruct [:uuid, :quantity_in_stock]

  def execute(
        %StoreItem{uuid: store_item_uuid, quantity_in_stock: quantity_in_stock},
        %PullFromStoreStock{
          stock_transfer_uuid: stock_transfer_uuid,
          quantity_requested: quantity_requested
        }
      ) do
    if quantity_in_stock >= quantity_requested do
      new_stock = quantity_in_stock - quantity_requested

      %PulledFromStoreStock{
        store_item_uuid: store_item_uuid,
        new_quantity_in_stock: new_stock,
        stock_transfer_uuid: stock_transfer_uuid
      }
    else
      {:error, :insufficient_stock_available}
    end
  end

  def apply(%StoreItem{uuid: store_item_uuid} = store_item, %PulledFromStoreStock{
        store_item_uuid: store_item_uuid,
        new_quantity_in_stock: stock
      }) do
    %StoreItem{
      store_item
      | quantity_in_stock: stock
    }
  end
end
