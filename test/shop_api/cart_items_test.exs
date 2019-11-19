defmodule ShopAPIWeb.CartItemsTest do
  use ShopAPIWeb.ConnCase
  alias ShopAPI.CartItems
  alias ShopAPI.Projections.CartItem

  describe "add_item/1" do
    test "returns an :ok tuple with valid changeset params" do
      cart_item_params = %{
        cart_uuid: Application.get_env(:shop_api, :default_cart_uuid),
        store_item_uuid: UUID.uuid4(),
        quantity_requested: 2
      }

      assert {:ok, %CartItem{}} = CartItems.add_item(cart_item_params)
    end

    test "returns a validation error when missing a params" do
      cart_item_params = %{cart_uuid: nil, store_item_uuid: UUID.uuid4(), quantity_requested: 2}

      assert {:validation_error, changeset} = CartItems.add_item(cart_item_params)
    end

    test "returns a validation error when given an empty params map" do
      cart_item_params = %{}

      assert {:validation_error, changeset} = CartItems.add_item(cart_item_params)
    end
  end
end
