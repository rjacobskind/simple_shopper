defmodule ShopAPI.ProjectorCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias ShopAPI.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import ShopAPI.DataCase

      import ShopAPI.Test.ProjectorUtils
    end
  end

  setup _tags do
    :ok = ShopAPI.Test.ProjectorUtils.truncate_database()

    :ok
  end
end
