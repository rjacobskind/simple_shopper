# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ShopAPI.Repo.insert!(%ShopAPI.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ShopAPI.Repo
alias ShopAPI.Projections.StoreItem

Repo.insert!(%StoreItem{
  uuid: UUID.uuid4(),
  quantity_in_stock: 15
})

Repo.insert!(%StoreItem{
  uuid: UUID.uuid4(),
  quantity_in_stock: 5
})

Repo.insert!(%StoreItem{
  uuid: UUID.uuid4(),
  quantity_in_stock: 23
})

Repo.insert!(%StoreItem{
  uuid: UUID.uuid4(),
  quantity_in_stock: 1
})

Repo.insert!(%StoreItem{
  uuid: UUID.uuid4(),
  quantity_in_stock: 0
})
