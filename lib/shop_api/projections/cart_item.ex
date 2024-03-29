defmodule ShopAPI.Projections.CartItem do
  @moduledoc """
  This struct holds the shopping CartItem. This is the projection for the read model.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key {:uuid, :binary_id, autogenerate: false}
  schema "cart_items" do
    field(:cart_id, :string)
    field(:store_item_uuid, :string)
    field(:quantity_requested, :integer)

    timestamps()
  end

  def changeset(cart_item_params) do
    %__MODULE__{}
    |> cast(cart_item_params, [:uuid, :quantity_requested, :store_item_uuid, :cart_id])
    |> validate_required([:quantity_requested, :store_item_uuid, :cart_id])
    |> validate_number(:quantity_requested, greater_than: 0)
  end
end
