defmodule ShopAPI.Projections.Cart do
  @moduledoc """
  This struct holds the shopping Cart. This is the projection for the read model.
  """
  use Ecto.Schema

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "carts" do
  end
end
