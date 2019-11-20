defmodule ShopApi.Aggregates.StoreItemTest do
  use ShopAPI.Test.InMemoryEventStoreCase
  alias ShopAPI.Aggregates.StoreItem
  alias ShopAPI.Events.PulledFromStoreStock
  alias ShopAPI.Commands.PullFromStoreStock

  test "ensure aggregate gets correct state on creation" do
    store_item_uuid = UUID.uuid4()

    store_item =
      %StoreItem{}
      |> evolve(%PulledFromStoreStock{
        new_quantity_in_stock: 3,
        store_item_uuid: store_item_uuid
      })

    assert store_item.quantity_in_stock == 3
    assert store_item.uuid == store_item_uuid
  end

  test "errors when there is not enough stock available" do
    store_item_uuid = UUID.uuid4()

    command = %PullFromStoreStock{
      store_item_uuid: store_item_uuid,
      quantity_requested: 5
    }

    assert {:error, :insufficient_stock_available} =
             StoreItem.execute(%StoreItem{uuid: store_item_uuid, quantity_in_stock: 2}, command)
  end

  test "emits event when there is enough stock available" do
    store_item_uuid = UUID.uuid4()

    command = %PullFromStoreStock{
      store_item_uuid: store_item_uuid,
      quantity_requested: 2
    }

    assert %PulledFromStoreStock{new_quantity_in_stock: 3} =
             StoreItem.execute(%StoreItem{uuid: store_item_uuid, quantity_in_stock: 5}, command)
  end
end
