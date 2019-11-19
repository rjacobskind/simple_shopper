defmodule ShopAPI.Router do
  use Commanded.Commands.Router

  alias ShopAPI.Aggregates.{CartItem, StoreItem}
  alias ShopAPI.Commands.{AddCartItem, PullFromStoreStock}

  dispatch([AddCartItem], to: CartItem, identity: :cart_item_uuid)
  dispatch([PullFromStoreStock], to: StoreItem, identity: :store_item_uuid)
end
