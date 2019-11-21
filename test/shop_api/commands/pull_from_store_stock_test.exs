defmodule PullFromStoreStockText do
  use ShopAPI.Test.InMemoryEventStoreCase
  import Commanded.Assertions.EventAssertions
  alias ShopAPI.Router
  alias ShopAPI.Commands.PullFromStoreStock
  alias ShopAPI.Events.PulledFromStoreStock
  alias ShopAPI.Projections.StoreItem
  alias ShopAPI.Repo

  test "ensure %PulledFromStoreStock{} is published" do
    store_item_uuid = UUID.uuid4()
    insert_store_item(store_item_uuid)

    :ok =
      Router.dispatch(
        %PullFromStoreStock{store_item_uuid: store_item_uuid, quantity_requested: 2},
        consistency: :strong
      )

    assert_receive_event(ShopAPI, PulledFromStoreStock, fn event ->
      require IEx
      IEx.pry()
    end)
  end

  defp insert_store_item(uuid) do
    params = %{uuid: uuid, quantity_in_stock: 10}

    changeset = StoreItem.changeset(params)
    Repo.insert(changeset)
  end
end
