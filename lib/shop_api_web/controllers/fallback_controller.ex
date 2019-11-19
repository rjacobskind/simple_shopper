defmodule ShopAPIWeb.FallbackController do
  use ShopAPIWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ShopAPIWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :insufficient_stock_available}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ShopAPIWeb.ErrorView)
    |> assign(:message, "Insufficient stock available in store")
    |> render(:"422")
  end

  def call(conn, {:validation_error, _changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ShopAPIWeb.ErrorView)
    |> render(:"422")
  end
end
