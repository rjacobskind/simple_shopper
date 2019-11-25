defmodule ShopAPI.Projectors.CartItem do
  use Commanded.Projections.Ecto,
    name: "Projectors.CartItem",
    consistency: :strong

  alias Ecto.{Changeset, Multi}
  alias ShopAPI.Events.AddedToCart
  alias ShopAPI.Projections.CartItem
  alias ShopAPI.Repo

  project(%AddedToCart{} = evt, _metadata, fn multi ->
    with %CartItem{} = cart_item <- Repo.get(CartItem, evt.cart_item_uuid) do
      multi_res =
        Multi.update(
          multi,
          :cart_item,
          Changeset.change(cart_item, quantity_requested: evt.new_cart_quantity)
        )
    else
      nil ->
        cart_uuid = Application.get_env(:shop_api, :default_cart_uuid)

        Multi.insert(
          multi,
          :cart_item,
          CartItem.changeset(%{
            uuid: evt.cart_item_uuid,
            quantity_requested: evt.new_cart_quantity,
            store_item_uuid: evt.store_item_uuid,
            cart_uuid: cart_uuid
          })
        )

      _ ->
        multi
    end
  end)
end
