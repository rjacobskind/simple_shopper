defmodule ShopAPI.Commands.PullFromStoreStock do
  @enforce_keys [:store_item_uuid]

  defstruct [:stock_transfer_uuid, :store_item_uuid, :quantity_requested]
end
