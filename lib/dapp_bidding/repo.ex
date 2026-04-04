defmodule DappBidding.Repo do
  use Ecto.Repo,
    otp_app: :dapp_bidding,
    adapter: Ecto.Adapters.Postgres
end
