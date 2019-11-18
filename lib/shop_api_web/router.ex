defmodule ShopAPIWeb.Router do
  use ShopAPIWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ShopAPIWeb do
    pipe_through(:api)

    resources("/cart", CartController, only[:create])
  end
end
