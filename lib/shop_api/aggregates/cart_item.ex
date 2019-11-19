defmodule ShopAPI.Aggregates.CartItem do
  @moduledoc """
  The cart item aggregate
  """
  defstruct uuid: nil, store_item_uuid: nil, quantity: nil

  alias __MODULE__
  alias ShopAPI.Commands.AddNewCartItem
  alias ShopAPI.Events.AddNewCartItemRequested

  def execute(%CartItem{uuid: nil}, %AddNewCartItem{
        cart_item_uuid: cart_item_uuid,
        store_item_uuid: store_item_uuid,
        quantity_requested: quantity_requested
      })
      when quantity_requested > 0 do
    %AddNewCartItemRequested{
      cart_item_uuid: cart_item_uuid,
      store_item_uuid: store_item_uuid,
      quantity_requested: quantity_requested
    }
  end

  def execute(%CartItem{uuid: nil}, %AddNewCartItem{
        quantity_requested: quantity_requested
      })
      when quantity_requested <= 0 do
    {:error, :quantity_must_be_above_zero}
  end

  def execute(%CartItem{}, %AddNewCartItem{}) do
    {:error, :cart_item_already_exists}
  end
end
