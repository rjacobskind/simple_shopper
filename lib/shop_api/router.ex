defmodule ShopAPI.Router do
  use Commanded.Commands.Router

  alias ShopAPI.Aggregates.{CartItem, StoreItem}
  alias ShopAPI.Commands.{RequestAddCartItem, AddToCart, PullFromStoreStock}

  dispatch([RequestAddCartItem, AddToCart], to: CartItem, identity: :cart_item_uuid)
  dispatch([PullFromStoreStock], to: StoreItem, identity: :store_item_uuid)
end
