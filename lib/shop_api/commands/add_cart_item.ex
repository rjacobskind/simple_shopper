defmodule ShopAPI.Commands.AddCartItem do
  @enforce_keys [:cart_item_uuid]

  defstruct [:stock_transfer_uuid, :cart_item_uuid, :store_item_uuid, :quantity_requested]
end
