defmodule ShopAPI.Commands.AddToCart do
  @enforce_keys [:stock_transfer_uuid]

  defstruct [
    :stock_transfer_uuid,
    :store_item_uuid,
    :quantity_requested,
    :cart_item_uuid,
    :cart_uuid
  ]
end
