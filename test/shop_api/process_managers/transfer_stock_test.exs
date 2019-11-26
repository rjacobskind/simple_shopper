defmodule ShopAPI.ProcessManagers.TransferStockTest do
  use ShopAPI.Test.InMemoryEventStoreCase
  alias ShopAPI.Commands.RequestAddCartItem
  alias ShopAPI.Events.{AddedToCart, PulledFromStoreStock, AddCartItemRequested}
  alias ShopAPI.Projections.{StoreItem, CartItem}
  alias ShopAPI.{Repo, Router}

  test "results in 2 published events -- PulledFromStoreStock and AddedCartItem" do
    cart_item_uuid = UUID.uuid4()
    store_item_uuid = UUID.uuid4()
    quantity_requested = 3

    {:ok, original_store_item} = insert_store_item(store_item_uuid)
    {:ok, original_cart_item} = insert_cart_item(cart_item_uuid, store_item_uuid)

    :ok =
      Router.dispatch(
        %RequestAddCartItem{
          cart_item_uuid: cart_item_uuid,
          store_item_uuid: store_item_uuid,
          quantity_requested: quantity_requested
        },
        consistency: :strong
      )

    assert_receive_event(AddCartItemRequested, fn event ->
      assert event.quantity_requested == 3
      assert event.store_item_uuid == store_item_uuid
      assert event.cart_item_uuid == cart_item_uuid
    end)

    assert_receive_event(PulledFromStoreStock, fn event ->
      assert event.new_quantity_in_stock == 8
      assert event.store_item_uuid == store_item_uuid
    end)

    assert_receive_event(AddedToCart, fn event ->
      assert event.new_cart_quantity == 3
      assert event.cart_item_uuid == cart_item_uuid
      assert event.store_item_uuid == store_item_uuid
    end)

    updated_store_item = Repo.get(StoreItem, store_item_uuid)
    updated_cart_item = Repo.get(CartItem, cart_item_uuid)

    assert original_store_item.quantity_in_stock == 10
    assert updated_store_item.quantity_in_stock == 8

    assert original_cart_item.quantity_requested == 1
    assert updated_cart_item.quantity_requested == 3
  end

  defp insert_store_item(uuid) do
    params = %{uuid: uuid, quantity_in_stock: 10}

    changeset = StoreItem.changeset(params)
    Repo.insert(changeset)
  end

  defp insert_cart_item(uuid, store_item_uuid) do
    cart_id = Application.get_env(:shop_api, :default_cart_id)

    params = %{
      uuid: uuid,
      cart_id: cart_id,
      store_item_uuid: store_item_uuid,
      quantity_requested: 1
    }

    changeset = CartItem.changeset(params)
    Repo.insert(changeset)
  end
end
