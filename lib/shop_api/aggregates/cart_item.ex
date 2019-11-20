defmodule ShopAPI.Aggregates.CartItem do
  @moduledoc """
  The cart item aggregate
  """
  defstruct uuid: nil, store_item_uuid: nil, quantity: nil

  alias __MODULE__
  alias ShopAPI.Projections.CartItem, as: CartItemProjection
  alias ShopAPI.Commands.{AddToCart, RequestAddCartItem}
  alias ShopAPI.Events.{AddCartItemRequested, AddedToCart}
  alias ShopAPI.Repo

  def execute(%CartItem{}, %RequestAddCartItem{
        quantity_requested: quantity_requested
      })
      when quantity_requested <= 0 do
    {:error, :quantity_must_be_above_zero}
  end

  def execute(%CartItem{}, %RequestAddCartItem{
        stock_transfer_uuid: stock_transfer_uuid,
        cart_item_uuid: cart_item_uuid,
        store_item_uuid: store_item_uuid,
        quantity_requested: quantity_requested
      })
      when quantity_requested > 0 do
    %AddCartItemRequested{
      stock_transfer_uuid: stock_transfer_uuid,
      cart_item_uuid: cart_item_uuid,
      store_item_uuid: store_item_uuid,
      quantity_requested: quantity_requested
    }
  end

  def execute(%CartItem{}, %AddToCart{
        cart_uuid: cart_uuid,
        stock_transfer_uuid: stock_transfer_uuid,
        quantity_requested: quantity_requested,
        store_item_uuid: store_item_uuid
      }) do
    existing_cart_item =
      Repo.get_by(CartItemProjection, cart_uuid: cart_uuid, store_item_uuid: store_item_uuid)

    cart_item_uuid = get_cart_item_uuid(existing_cart_item)

    %AddedToCart{
      cart_item_uuid: cart_item_uuid,
      new_cart_quantity: quantity_requested,
      store_item_uuid: store_item_uuid,
      stock_transfer_uuid: stock_transfer_uuid
    }
  end

  def apply(%CartItem{} = cart_item, %AddCartItemRequested{}) do
    cart_item
  end

  def apply(%CartItem{} = cart_item, %AddedToCart{} = evt) do
    %CartItem{
      cart_item
      | uuid: evt.cart_item_uuid,
        quantity: evt.new_cart_quantity,
        store_item_uuid: evt.store_item_uuid
    }
  end

  defp get_cart_item_uuid(nil), do: UUID.uuid4()
  defp get_cart_item_uuid(existing_cart_item), do: existing_cart_item.uuid
end
