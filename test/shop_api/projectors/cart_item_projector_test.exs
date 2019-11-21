defmodule ShopAPI.Projectors.CartItemProjectorTest do
  use ShopAPI.ProjectorCase

  alias ShopAPI.Projections.CartItem
  alias ShopAPI.Projectors.CartItem, as: Projector
  alias ShopAPI.Events.AddedToCart

  test "should succeed with valid data" do
    cart_item_uuid = UUID.uuid4()
    store_item_uuid = UUID.uuid4()

    event = %AddedToCart{
      cart_item_uuid: cart_item_uuid,
      new_cart_quantity: 2,
      store_item_uuid: store_item_uuid
    }

    last_seen_event_number = get_last_seen_event_number("Projectors.CartItem")
    assert :ok = Projector.handle(event, %{event_number: last_seen_event_number + 1})

    assert only_instance_of(CartItem).uuid == cart_item_uuid
    assert only_instance_of(CartItem).quantity_requested == 2
    assert only_instance_of(CartItem).store_item_uuid == store_item_uuid
  end
end
