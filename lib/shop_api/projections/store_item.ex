defmodule ShopAPI.Projections.StoreItem do
  @moduledoc """
  This struct holds the StoreItem. This is the projection for the read model.
  """
  use Ecto.Schema

  @type t :: %__MODULE__{}

  @foreign_key_type :binary_id
  schema "store_items" do
    field(:quantity_in_stock, :integer)
  end
end
