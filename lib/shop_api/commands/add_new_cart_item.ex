defmodule ShopAPI.Commands.AddNewCartItem do
  @enforce_keys [:cart_item_uuid]

  defstruct [:cart_item_uuid, :store_item_uuid, :quantity_requested]
end
