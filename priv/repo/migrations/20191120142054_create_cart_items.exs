defmodule ShopAPI.Repo.Migrations.CreateCartItems do
  use Ecto.Migration

  def change do
    create table(:cart_items, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :cart_uuid, :string
      add :store_item_uuid, :string
      add :quantity_requested, :integer, default: 0

      timestamps()
    end
  end
end
