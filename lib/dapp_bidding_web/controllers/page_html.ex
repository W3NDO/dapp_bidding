defmodule DappBiddingWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use DappBiddingWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns.current_user, label: "Current User")

    if socket.assigns[:current_user] == nil do
      {:ok,
       socket
       |> put_flash(:error, "You must be logged in to play the game")
       |> redirect(to: ~p"/")}
    else
      {:ok, socket}
    end
  end
end
