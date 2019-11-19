defmodule ShopAPI.CartItems do
  @moduledoc """
  The context module for cart items
  """
  alias ShopAPI.Projections.CartItem
  alias ShopAPI.Commands.AddNewCartItem
  alias ShopAPI.Router

  def add_new_item(cart_item_params) do
    changeset = CartItem.add_new_item_changeset(cart_item_params)

    if changeset.valid? do
      cart_item_uuid = UUID.uuid4()

      dispatch_result =
        %AddNewCartItem{
          cart_item_uuid: cart_item_uuid,
          store_item_uuid: changeset.changes.store_item_uuid,
          quantity_requested: changeset.changes.quantity_requested
        }
        |> Router.dispatch()

      case dispatch_result do
        :ok ->
          %CartItem{
            uuid: cart_item_uuid,
            store_item_id: changeset.changes.store_item_id,
            quantity_requested: changeset.changes.quantity_requested
          }

        reply ->
          reply
      end
    else
      {:validation_error, changeset}
    end
  end
end
