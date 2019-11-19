defmodule ShopAPI.Projections.StoreItem do
  @moduledoc """
  This struct holds the StoreItem. This is the projection for the read model.
  """
  use Ecto.Schema

  @type t :: %__MODULE__{}

  @primary_key {:uuid, :binary_id, autogenerate: false}
  schema "store_items" do
    field(:quantity_in_stock, :integer)
  end
end
