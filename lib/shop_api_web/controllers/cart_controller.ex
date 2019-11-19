defmodule ShopAPIWeb.CartController do
  use ShopAPIWeb, :controller

  alias ShopAPI.CartItems
  alias ShopAPI.Projections.CartItem

  action_fallback(ShopAPIWeb.FallbackController)

  def create(conn, %{"cart_item" => cart_item_params}) do
    with {:ok, %CartItem{} = cart_item} <- CartItems.add_new_item(cart_item_params) do
      conn
      |> put_status(:created)
      |> render("show.json", cart_item: cart_item)
    end
  end
end
