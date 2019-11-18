defmodule ShopAPIWeb.ShopControllerTest do
  use ShopAPIWeb.ConnCase

  @create_attrs %{
    quantity: 2
  }
  @invalid_attrs %{
    quantity: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create cart" do
    test "renders cart when data is valid", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.cart_path(conn, :create),
          cart_item: @create_attrs
        )

      assert %{
               "uuid" => _uuid
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.cart_path(conn, :create),
          cart_item: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
