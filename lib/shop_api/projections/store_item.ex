defmodule ShopAPI.Projections.StoreItem do
  @moduledoc """
  This struct holds the StoreItem. This is the projection for the read model.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key {:uuid, :binary_id, autogenerate: false}
  schema "store_items" do
    field(:quantity_in_stock, :integer, default: 0)

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:uuid, :quantity_in_stock])
    |> validate_required([:uuid, :quantity_in_stock])
  end
end
