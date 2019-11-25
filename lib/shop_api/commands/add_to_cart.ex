defmodule ShopAPI.Commands.AddToCart do
  @enforce_keys [:cart_item_uuid]
  @uuid_regex ~r/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
  defstruct [
    :stock_transfer_uuid,
    :store_item_uuid,
    :quantity_requested,
    :cart_item_uuid,
    :cart_uuid
  ]

  def valid?(command) do
    Skooma.valid?(Map.from_struct(command), schema())
  end

  defp schema do
    %{
      stock_transfer_uuid: [:string, Skooma.Validators.regex(@uuid_regex)],
      store_item_uuid: [:string, Skooma.Validators.regex(@uuid_regex)],
      quantity_requested: [:int, &positive_integer(&1)],
      cart_item_uuid: [:string, Skooma.Validators.regex(@uuid_regex)],
      cart_uuid: [:string, &(&1 == "123")]
    }
  end

  defp positive_integer(data) do
    cond do
      is_integer(data) ->
        if data > 0 do
          :ok
        else
          {:error, "Argument must be bigger than zero"}
        end

      true ->
        {:error, "Argument must be an integer"}
    end
  end
end
