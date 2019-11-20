defmodule ShopApi.Aggregates.CartItemTest do
  use ShopAPI.Test.InMemoryEventStoreCase
  alias ShopAPI.Projections.CartItem, as: CartItemProjection
  alias ShopAPI.Aggregates.CartItem
  alias ShopAPI.Events.{AddedToCart, AddCartItemRequested}
  alias ShopAPI.Commands.{AddToCart, RequestAddCartItem}
  alias ShopAPI.Repo

  test "ensure aggregate gets correct state on creation" do
    cart_item_uuid = UUID.uuid4()
    store_item_uuid = UUID.uuid4()

    cart_item =
      %CartItem{}
      |> evolve(%AddedToCart{
        cart_item_uuid: cart_item_uuid,
        new_cart_quantity: 4,
        store_item_uuid: store_item_uuid
      })

    assert cart_item.uuid == cart_item_uuid
    assert cart_item.quantity == 4
    assert cart_item.store_item_uuid == store_item_uuid
  end

  # test "ensure aggregate get correct state when adding a cart item" do
  # cart_item_uuid = UUID.uuid4()
  # store_item_uuid = UUID.uuid4()
  # cart_uuid = Application.get_env(:shop_api, :default_cart_uuid)
  # end

  test "emits an addedtocart event and adds to preexisting cart item when an addtocart command with the proper params is received" do
    cart_item_uuid = UUID.uuid4()
    store_item_uuid = UUID.uuid4()
    stock_transfer_uuid = UUID.uuid4()
    cart_uuid = Application.get_env(:shop_api, :default_cart_uuid)

    Repo.insert(%CartItemProjection{
      uuid: cart_item_uuid,
      cart_uuid: cart_uuid,
      store_item_uuid: store_item_uuid,
      quantity_requested: 2
    })

    res =
      CartItem.execute(%CartItem{}, %AddToCart{
        store_item_uuid: store_item_uuid,
        quantity_requested: 3,
        cart_item_uuid: cart_item_uuid,
        cart_uuid: cart_uuid,
        stock_transfer_uuid: stock_transfer_uuid
      })

    exp_res = %AddedToCart{
      cart_item_uuid: cart_item_uuid,
      store_item_uuid: store_item_uuid,
      new_cart_quantity: 3,
      stock_transfer_uuid: stock_transfer_uuid
    }

    assert res == exp_res
  end

  test "emits an addedtocart event and adds to new item when an addtocart command with the proper params is received" do
    store_item_uuid = UUID.uuid4()
    stock_transfer_uuid = UUID.uuid4()
    cart_uuid = Application.get_env(:shop_api, :default_cart_uuid)

    res =
      CartItem.execute(%CartItem{}, %AddToCart{
        store_item_uuid: store_item_uuid,
        quantity_requested: 3,
        cart_uuid: cart_uuid,
        stock_transfer_uuid: stock_transfer_uuid
      })

    assert res.store_item_uuid == store_item_uuid

    assert res.new_cart_quantity == 3
    assert res.stock_transfer_uuid == stock_transfer_uuid
  end

  test "emits a request event when a request command with the proper params is received" do
    stock_transfer_uuid = UUID.uuid4()
    cart_item_uuid = UUID.uuid4()
    store_item_uuid = UUID.uuid4()

    res =
      CartItem.execute(%CartItem{}, %RequestAddCartItem{
        stock_transfer_uuid: stock_transfer_uuid,
        cart_item_uuid: cart_item_uuid,
        store_item_uuid: store_item_uuid,
        quantity_requested: 2
      })

    exp_res = %AddCartItemRequested{
      stock_transfer_uuid: stock_transfer_uuid,
      cart_item_uuid: cart_item_uuid,
      store_item_uuid: store_item_uuid,
      quantity_requested: 2
    }

    assert res == exp_res
  end

  test "errors when the requested quantity is not greater than zero" do
    res =
      CartItem.execute(%CartItem{}, %RequestAddCartItem{
        cart_item_uuid: UUID.uuid4(),
        quantity_requested: 0
      })

    assert res == {:error, :quantity_must_be_above_zero}
  end
end
