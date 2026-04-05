defmodule DappBiddingWeb.Landing do
  use DappBiddingWeb, :live_view

  def mount(_params, _session, socket) do
    contracts = DappBidding.Contracts.load_addresses()

    sample_items =
      contracts
      |> Enum.map (fn addr ->
        %{
        image: "https://picsum.photos/400/300",
        price: "120.00",# will change to highest bid.
        contract: addr,
        time_left: "2h 13m"
      }
      end)

    {:ok,
     socket
     |> assign(:wallet_address, nil)
     |> assign(:auction_items, sample_items)}
  end

  def handle_event("place_bid", %{"contract_address" => contract_address, "bid_amount" => bid_amount}, socket) do
    {:ok, _new_bid} = {:ok, "Hello"}
    IO.inspect("Bid placed #{contract_address} : #{[bid_amount]}")
    DappBidding.Contracts.bid(contract_address, bid_amount, "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80")
    {:noreply, socket}
  end

  def handle_event("wallet_connected", %{"address" => address}, socket) do
    {:noreply, socket |> assign(:wallet_address, address)}
  end
end
