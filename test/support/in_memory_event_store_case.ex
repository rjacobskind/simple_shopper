defmodule ShopAPI.Test.InMemoryEventStoreCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Commanded.Assertions.EventAssertions

      import ShopAPI.Test.AggregateUtils
    end
  end

  setup do
    on_exit(fn ->
      :ok = Application.stop(:shop_api)
      :ok = Application.stop(:commanded)

      {:ok, _apps} = Application.ensure_all_started(:shop_api)
    end)
  end
end
