defmodule ShopAPI.Aggregates.StoreItem do
  @moduledoc """
  The store item aggregate
  """
  alias __MODULE__
  alias ShopAPI.Commands.PullFromStoreStock
  alias ShopAPI.Events.PulledFromStoreStock
  alias ShopAPI.Projections.CartItem
  alias ShopAPI.Repo

  defstruct [:uuid, :quantity_in_stock]

  def execute(
        %StoreItem{uuid: store_item_uuid, quantity_in_stock: quantity_in_stock},
        %PullFromStoreStock{
          stock_transfer_uuid: stock_transfer_uuid,
          store_item_uuid: store_item_uuid,
          quantity_requested: quantity_requested
        }
      ) do
    cart_uuid = Application.get_env(:shop_api, :default_cart_uuid)

    existing_cart_item =
      Repo.get_by(CartItem, cart_uuid: cart_uuid, store_item_uuid: store_item_uuid)

    existing_cart_quantity = get_existing_cart_quantity(existing_cart_item)
    quantity_available = quantity_in_stock + existing_cart_quantity

    if quantity_available >= quantity_requested do
      new_stock = quantity_available - quantity_requested

      %PulledFromStoreStock{
        store_item_uuid: store_item_uuid,
        new_quantity_in_stock: new_stock,
        stock_transfer_uuid: stock_transfer_uuid
      }
    else
      {:error, :insufficient_stock_available}
    end
  end

  def execute(%StoreItem{}, %PullFromStoreStock{
        stock_transfer_uuid: stock_transfer_uuid,
        store_item_uuid: store_item_uuid,
        quantity_requested: quantity_requested
      }) do
    cart_uuid = Application.get_env(:shop_api, :default_cart_uuid)
    existing_store_item = Repo.get(ShopAPI.Projections.StoreItem, store_item_uuid)
    quantity_in_stock = get_quantity_in_stock(existing_store_item)

    existing_cart_item =
      Repo.get_by(CartItem, cart_uuid: cart_uuid, store_item_uuid: store_item_uuid)

    existing_cart_quantity = get_existing_cart_quantity(existing_cart_item)
    quantity_available = quantity_in_stock + existing_cart_quantity

    if quantity_available >= quantity_requested do
      new_stock = quantity_available - quantity_requested

      %PulledFromStoreStock{
        store_item_uuid: store_item_uuid,
        new_quantity_in_stock: new_stock,
        stock_transfer_uuid: stock_transfer_uuid
      }
    else
      {:error, :insufficient_stock_available}
    end
  end

  def apply(%StoreItem{} = store_item, %PulledFromStoreStock{
        store_item_uuid: store_item_uuid,
        new_quantity_in_stock: stock
      }) do
    %StoreItem{
      store_item
      | uuid: store_item_uuid,
        quantity_in_stock: stock
    }
  end

  defp get_existing_cart_quantity(nil), do: 0
  defp get_existing_cart_quantity(existing_cart_item), do: existing_cart_item.quantity_requested

  defp get_quantity_in_stock(nil), do: 0
  defp get_quantity_in_stock(existing_store_item), do: existing_store_item.quantity_in_stock
end
