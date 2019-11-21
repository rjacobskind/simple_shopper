defmodule ShopAPIWeb.CartView do
  use ShopAPIWeb, :view
  alias __MODULE__

  def render("show.json", %{cart_item: cart_item}) do
    %{data: render_one(cart_item, CartView, "cart_item.json", as: :cart_item)}
  end

  def render("cart_item.json", %{cart_item: cart_item}) do
    %{
      uuid: cart_item.uuid,
      cart_uuid: cart_item.cart_uuid,
      store_item_uuid: cart_item.store_item_uuid,
      quantity_requested: cart_item.quantity_requested
    }
  end
end
