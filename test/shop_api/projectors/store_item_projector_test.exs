defmodule ShopAPI.Projectors.StoreItemProjectorTest do
  use ShopAPI.ProjectorCase
  alias ShopAPI.Repo
  alias ShopAPI.Projections.StoreItem
  alias ShopAPI.Events.PulledFromStoreStock
  alias ShopAPI.Projectors.StoreItem, as: Projector

  test "should succeed with valid data" do
    store_item_uuid = UUID.uuid4()
    insert_store_item(store_item_uuid)

    event = %PulledFromStoreStock{store_item_uuid: store_item_uuid, new_quantity_in_stock: 6}
    last_seen_event_number = get_last_seen_event_number("Projectors.StoreItem")

    assert :ok = Projector.handle(event, %{event_number: last_seen_event_number + 1})

    assert only_instance_of(StoreItem).uuid == store_item_uuid
    assert only_instance_of(StoreItem).quantity_in_stock == 6
  end

  defp insert_store_item(uuid) do
    params = %{uuid: uuid, quantity_in_stock: 10}

    changeset = StoreItem.changeset(params)
    Repo.insert(changeset)
  end
end
