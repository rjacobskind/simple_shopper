defmodule ShopAPI.Commands.AddToCartTest do
  use ShopAPI.Test.InMemoryEventStoreCase
  import Commanded.Assertions.EventAssertions
  alias ShopAPI.Router
  alias ShopAPI.Repo
  alias ShopAPI.Projections.CartItem
  alias ShopAPI.Commands.AddToCart
  alias ShopAPI.Events.AddedToCart

  test "ensure %AddedToCart{} is published when cart item is pre-existing" do
    store_item_uuid = UUID.uuid4()
    cart_item_uuid = UUID.uuid4()

    cart_id = Application.get_env(:shop_api, :default_cart_id)

    {:ok, original_cart_item} = insert_cart_item(cart_item_uuid, store_item_uuid)

    :ok =
      Router.dispatch(
        %AddToCart{
          cart_item_uuid: cart_item_uuid,
          cart_id: cart_id,
          quantity_requested: 3,
          store_item_uuid: store_item_uuid
        },
        consistency: :strong
      )

    assert_receive_event(AddedToCart, fn event ->
      assert event.new_cart_quantity == 3
      assert event.cart_item_uuid == cart_item_uuid
    end)

    updated_cart_item = Repo.get(CartItem, cart_item_uuid)
    assert original_cart_item.uuid == updated_cart_item.uuid
    assert original_cart_item.quantity_requested == updated_cart_item.quantity_requested

    # IO.inspect(original_cart_item, label: "Original Cart Item\n\n")
    # IO.inspect(updated_cart_item, label: "Updated Cart Item\n\n")
  end

  test "ensure %AddedToCart{} is published when cart item does not yet exist" do
    store_item_uuid = UUID.uuid4()
    cart_item_uuid = UUID.uuid4()

    cart_id = Application.get_env(:shop_api, :default_cart_id)

    original_cart_item = Repo.get(CartItem, cart_item_uuid)

    :ok =
      Router.dispatch(
        %AddToCart{
          cart_item_uuid: cart_item_uuid,
          cart_id: cart_id,
          quantity_requested: 3,
          store_item_uuid: store_item_uuid
        },
        consistency: :strong
      )

    assert_receive_event(AddedToCart, fn event ->
      assert event.new_cart_quantity == 3
      assert event.cart_item_uuid == cart_item_uuid
    end)

    updated_cart_item = Repo.get(CartItem, cart_item_uuid)
    assert original_cart_item == nil
    assert updated_cart_item.quantity_requested == 3

    # IO.inspect(original_cart_item, label: "Original Cart Item\n\n")
    # IO.inspect(updated_cart_item, label: "Updated Cart Item\n\n")
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
