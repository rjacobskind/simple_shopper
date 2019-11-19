defmodule ShopAPI.Projections.CartItem do
  @moduledoc """
  This struct holds the shopping CartItem. This is the projection for the read model.
  """
  use Ecto.Schema

  @type t :: %__MODULE__{}

  @foreign_key_type :binary_id
  schema "cart_items" do
    field(:cart_id, :string)
    field(:store_item_id, :string)
    field(:quantity_requested, :integer)
  end
end
