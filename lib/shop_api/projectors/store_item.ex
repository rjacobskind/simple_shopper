defmodule ShopAPI.Projectors.StoreItem do
  use Commanded.Projections.Ecto,
    name: "Projectors.StoreItem",
    consistency: :strong

  alias Ecto.{Changeset, Multi}
  alias ShopAPI.Events.PulledFromStoreStock
  alias ShopAPI.Projections.StoreItem
  alias ShopAPI.Repo

  project(%PulledFromStoreStock{} = evt, _metadata, fn multi ->
    update_quantity_in_stock(multi, evt)
  end)

  # project(%AddToStoreStock{} = evt, _metadata, fn multi ->
  #   update_quantity_in_stock(multi, evt)
  # end)

  defp update_quantity_in_stock(multi, evt) do
    with %StoreItem{} = store_item <- Repo.get(StoreItem, evt.store_item_uuid) do
      Multi.update(
        multi,
        :store_item,
        Changeset.change(store_item, quantity_in_stock: evt.new_quantity_in_stock)
      )
    else
      _ -> multi
    end
  end
end
