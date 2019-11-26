defmodule ShopAPI.CartItems do
  @moduledoc """
  The context module for cart items
  """
  alias ShopAPI.Projections.CartItem
  alias ShopAPI.Commands.RequestAddCartItem
  alias ShopAPI.Router

  def add_item(cart_item_params) do
    changeset = CartItem.changeset(cart_item_params)

    if changeset.valid? do
      cart_item_uuid = get_cart_item_uuid(cart_item_params)

      dispatch_result =
        %RequestAddCartItem{
          cart_item_uuid: cart_item_uuid,
          store_item_uuid: changeset.changes.store_item_uuid,
          quantity_requested: changeset.changes.quantity_requested
        }
        |> Router.dispatch(consistency: :strong)

      case dispatch_result do
        :ok ->
          {:ok,
           %CartItem{
             uuid: cart_item_uuid,
             store_item_uuid: changeset.changes.store_item_uuid,
             quantity_requested: changeset.changes.quantity_requested
           }}

        reply ->
          reply
      end
    else
      {:validation_error, changeset}
    end
  end

  defp get_cart_item_uuid(%{cart_item_uuid: cart_item_uuid}), do: cart_item_uuid
  defp get_cart_item_uuid(_), do: UUID.uuid4()
end
