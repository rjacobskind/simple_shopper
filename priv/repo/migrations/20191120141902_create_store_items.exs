defmodule ShopAPI.Repo.Migrations.CreateStoreItems do
  use Ecto.Migration

  def change do
    create table(:store_items, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :quantity_in_stock, :integer, default: 0

      timestamps()
    end
  end
end
