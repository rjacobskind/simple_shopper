defmodule ShopAPI.Events.AddNewCartItemRequested do
  @moduledoc """
  The AddNewCartItemRequested event
  """
  defstruct [:cart_item_uuid, :store_item_uuid, :quantity_requested]
end
