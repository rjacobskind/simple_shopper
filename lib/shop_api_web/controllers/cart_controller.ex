defmodule ShopAPIWeb.Controllers.CartController do
  use ShopAPIWeb, :controller

  alias ShopAPI.Cart
  alias ShopAPI.Carts.Projections.CartItems

  action_fallback(ShopAPIWeb.FallbackController)

  def create(conn, %{"cart_item" => cart_item_params}) do
    with {:ok, %Cart{} = cart} <- Carts.add_cart_item(cart_item_params) do
      conn
      |> put_status(:created)
      |> render("show.json", cart: cart)
    end
  end
end
