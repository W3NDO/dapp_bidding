defmodule DappBiddingWeb.Landing do
  use DappBiddingWeb, :live_view

  def mount(_params, _session, socket) do
    sample_items = [
        %{
            image: "https://picsum.photos/400/300",
            price: "120.00",
            seller: "John 123",
            time_left: "2h 13m"
        },
        %{
            image: "https://picsum.photos/400/300",
            price: "120.00",
            seller: "John 123",
            time_left: "2h 13m"
        },
        %{
            image: "https://picsum.photos/400/300",
            price: "120.00",
            seller: "John 123",
            time_left: "2h 13m"
        },
        %{
            image: "https://picsum.photos/400/300",
            price: "120.00",
            seller: "John 123",
            time_left: "2h 13m"
        },
        %{
            image: "https://picsum.photos/400/300",
            price: "120.00",
            seller: "John 123",
            time_left: "2h 13m"
        }
    ]
    {:ok,
      socket
      |> assign(:wallet_address, nil)
      |> assign(:auction_items, sample_items)
    }
  end

  def handle_event("place_bid", _value, socket) do
    {:ok, _new_bid} = {:ok, "Hello" }
    IO.inspect("Bid placed")
    {:noreply, socket}
  end

  def handle_event("wallet_connected", %{"address" => address}, socket) do
    {:noreply, socket |> assign(:wallet_address, address)}
  end
end
