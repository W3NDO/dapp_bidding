defmodule DappBiddingWeb.Landing do
  use DappBiddingWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("place_bid", _value, socket) do
    {:ok, _new_bid} = {:ok, "Hello" }
    IO.inspect("Bid placed")
    {:noreply, socket}
  end
end
