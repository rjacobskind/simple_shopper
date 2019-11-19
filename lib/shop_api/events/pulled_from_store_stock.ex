defmodule ShopAPI.Events.PulledFromStoreStock do
  @moduledoc """
  The PulledFromStoreStock event
  """
  @derive [Jason.Encoder]

  defstruct [:stock_transfer_uuid, :store_item_uuid, :new_quantity_in_stock]
end
