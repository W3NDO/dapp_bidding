defmodule DappBiddingWeb.Components.ItemCardComponent do
  use Phoenix.Component

  attr :image, :string, required: true
  attr :price, :string, required: true
  attr :contract, :string, required: true
  attr :time_left, :string, required: true

  def card(assigns) do
    ~H"""
    <div class="max-w-sm rounded-md overflow-hidden shadow-lg bg-green-900 hover:shadow-xl transition-shadow duration-300 m-2">
      <div class="h-48 w-full overflow-hidden">
        <img src={@image} alt="item image" class="w-full h-full object-cover" />
      </div>

      <div class="p-4 flex flex-col gap-3">
        <div class="flex justify-between items-center">
          <span class="text-lg font-semibold text-gray-800">
            {@price}
          </span>
          <span class="text-sm text-red-500 font-medium">
            {@time_left}
          </span>
        </div>

        <div class="text-sm text-black">
          Seller: <span class="font-medium text-gray-800">{@contract}</span>
        </div>

        <form phx-submit="place_bid" class="mt-4">
          <input
            type="number"
            name="bid_amount"
            step="any"
            class="w-full p-2 rounded-xl border border-gray-300"
            placeholder="Enter bid amount (wei)"
          />

          <button
            type="submit"
            class="mt-2 w-full bg-purple-600 text-black py-2 rounded-xl hover:bg-blue-700 transition"
          >
            Place Bid
          </button>

          <input type="hidden" name="contract_address" value={@contract} />
        </form>

      </div>
    </div>
    """
  end
end
