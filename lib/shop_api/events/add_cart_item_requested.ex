defmodule ShopAPI.Events.AddCartItemRequested do
  @moduledoc """
  The AddCartItemRequested event
  """
  @derive [Jason.Encoder]
  defstruct [:stock_transfer_uuid, :cart_item_uuid, :store_item_uuid, :quantity_requested]
end
