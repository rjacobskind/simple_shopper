defmodule ShopAPI.Router do
  use Commanded.Commands.Router

  alias ShopAPI.Aggregates.CartItem
  alias ShopAPI.Commands.AddNewCartItem

  dispatch([AddNewCartItem], to: CartItem, identity: :cart_item_uuid)
end
