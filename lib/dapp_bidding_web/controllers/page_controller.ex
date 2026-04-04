defmodule DappBiddingWeb.PageController do
  use DappBiddingWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
