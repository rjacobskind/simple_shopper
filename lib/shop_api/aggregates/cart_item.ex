defmodule ShopAPI.Aggregates.CartItem do
  @moduledoc """
  The cart item aggregate
  """
  defstruct uuid: nil, store_item_uuid: nil, quantity: nil

  alias __MODULE__
  alias ShopAPI.Commands.AddCartItem
  alias ShopAPI.Events.AddCartItemRequested

  def execute(%CartItem{uuid: nil}, %AddCartItem{
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

  def execute(%CartItem{uuid: nil}, %AddCartItem{
        quantity_requested: quantity_requested
      })
      when quantity_requested <= 0 do
    {:error, :quantity_must_be_above_zero}
  end

  def execute(%CartItem{}, %AddCartItem{}) do
    {:error, :cart_item_already_exists}
  end

  def apply(%CartItem{} = cart_item, %AddCartItemRequested{}) do
    cart_item
  end
end
