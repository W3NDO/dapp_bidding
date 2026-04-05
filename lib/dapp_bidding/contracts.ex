defmodule DappBidding.Contracts do
  @moduledoc """
  FOr the MVP we justy want the client to be able to triggger a bid from the front end
  """

  @rpc "http://127.0.0.1:8545"

  alias Ethereumex.HttpClient

  @doc """
  Send a bid tx to the auction contract

  contract_address - deployed auction contract
  value_wei - bid amount in wei
  private_key - anvil account private key
  """
  def bid(contract_address, value_wei, private_key) do
    value_eth = wei_to_eth(value_wei)

    args = [
      "send",
      contract_address,
      "bid()",
      "--value",
      value_eth,
      "--private-key",
      private_key,
      "--rpc-url",
      @rpc
    ]

    case System.cmd("cast", args, stderr_to_stdout: true) do
      {output, 0} ->
        {:ok, parse_tx_hash(output)}

      {error, code} ->
        {:error, %{code: code, message: error}}
    end
  end

  defp wei_to_eth(wei) do
    # convert wei → ether string (cast expects "1ether", "0.1ether", etc.)
    "#{Decimal.div(Decimal.new(wei), Decimal.new(1_000_000_000_000_000_000))}ether"
  end

  defp parse_tx_hash(output) do
    output
    |> String.trim()
    |> String.split("\n")
    |> List.last()
  end

  @doc """
  Get addresses of the contracts
  """
  def load_addresses do
    "solidity_contract/bidder/broadcast/DeployAuction.s.sol/31337/run-latest.json"
    |> File.read!()
    |> Jason.decode!()
    |> extract_addresses()
  end

  defp extract_addresses(json) do
    json["transactions"]
    |> Enum.filter(&(&1["contractAddress"]))
    |> Enum.map(& &1["contractAddress"])
  end
end
