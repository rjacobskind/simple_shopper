defmodule ShopAPI.Events.AddedToCart do
  @moduledoc """
  The AddedToCart event
  """
  @derive [Jason.Encoder]

  defstruct [:stock_transfer_uuid, :cart_item_uuid, :new_cart_quantity, :store_item_uuid]
end
