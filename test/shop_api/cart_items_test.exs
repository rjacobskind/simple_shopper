defmodule ShopAPIWeb.CartItemsTest do
  use ShopAPI.Test.InMemoryEventStoreCase
  use ShopAPIWeb.ConnCase
  alias ShopAPI.CartItems
  alias ShopAPI.Projections.{CartItem, StoreItem}
  alias ShopAPI.Repo

  setup do
    store_item_uuid = UUID.uuid4()
    insert_store_item(store_item_uuid)
    {:ok, store_item_uuid: store_item_uuid}
  end

  describe "add_item/1" do
    test "returns an :ok tuple with valid changeset params", %{store_item_uuid: store_item_uuid} do
      cart_item_params = %{
        cart_uuid: Application.get_env(:shop_api, :default_cart_uuid),
        store_item_uuid: store_item_uuid,
        quantity_requested: 2
      }

      assert {:ok, %CartItem{}} = CartItems.add_item(cart_item_params)
    end

    test "returns a validation error when missing a params", %{store_item_uuid: store_item_uuid} do
      cart_item_params = %{
        cart_uuid: nil,
        store_item_uuid: store_item_uuid,
        quantity_requested: 2
      }

      assert {:validation_error, changeset} = CartItems.add_item(cart_item_params)
    end

    test "returns a validation error when given an empty params map" do
      cart_item_params = %{}

      assert {:validation_error, changeset} = CartItems.add_item(cart_item_params)
    end
  end

  defp insert_store_item(uuid) do
    params = %{uuid: uuid, quantity_in_stock: 10}

    changeset = StoreItem.changeset(params)
    Repo.insert(changeset)
  end
end
