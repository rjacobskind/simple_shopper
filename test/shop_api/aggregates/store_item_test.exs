defmodule ShopApi.Aggregates.StoreItemTest do
  use ShopAPI.Test.InMemoryEventStoreCase
  alias ShopAPI.Aggregates.StoreItem
  alias ShopAPI.Events.PulledFromStoreStock

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
end

# stock_transfer_uuid, :store_item_uuid, :new_quantity_in_stock]

# execute(
#         %StoreItem{uuid: store_item_uuid, quantity_in_stock: quantity_in_stock},
#         %PullFromStoreStock{
#           stock_transfer_uuid: stock_transfer_uuid,
#           quantity_requested: quantity_requested
#         }
#       )
