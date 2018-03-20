defmodule Blockchain do
  @moduledoc """
  Documentation for Blockchain.
  """

  alias Blockchain.Core

  defp new_block(proof, previous_hash) do
    block = %Block{
      index: Core.get_next_block_index,
      timestamp: NaiveDateTime.to_string(NaiveDateTime.utc_now),
      transactions: Core.get_transactions(),
      proof: proof,
      previous_hash: previous_hash
    }

    # Reset the current list of transactions
    Core.reset_transactions()

    Core.add_block(block)
  end
  
  def new_transaction(sender, recipient, amount) do
    %Transaction{
      sender: sender,
      recipient: recipient,
      amount: amount,
#      block_index: Core.get_next_block_index
    }
    |> Core.add_transaction()
  end

  def hash(input) when is_bitstring(input) do
    :crypto.hash(:sha256, input) |> Base.encode16(case: :lower)
  end
  def hash(input) when is_map(input) do
    :crypto.hash(:sha256, Jason.encode!(input)) |> Base.encode16(case: :lower)
  end

  @doc"""
  Simple Proof of Work Algorithm:
   - Find a number p' such that hash(pp') contains leading 4 zeroes, where p is the previous p'
   - p is the previous proof, and p' is the new proof
  :param last_proof: <int>
  :return: <int>
  """
  def proof_of_work(last_proof) do
    proof = 0

    valid_proof(last_proof, proof)
  end

  @doc"""
  Validates the Proof: Does hash(last_proof, proof) contain 4 leading zeroes?
  :param last_proof: <int> Previous Proof
  :param proof: <int> Current Proof
  :return: <bool> True if correct, False if not.
  """
  def valid_proof(last_proof, proof) do
    guess_hash = hash("#{last_proof}#{proof}")
    IO.inspect(guess_hash)

    if String.slice(guess_hash, -4, 4) == "0000",
      do: proof,
      else: valid_proof(last_proof, proof + 1)
  end

  def mine do
    # We run the proof of work algorithm to get the next proof...

    proof =
      Core.get_last_block_proof
      |> proof_of_work()

    # We must receive a reward for finding the proof.
    # The sender is "0" to signify that this node has mined a new coin.
    new_transaction(
      "0",
      "node_address_for_reward", #self()
      1 # Reward
    )

    # Forge the new Block by adding it to the chain
    previous_hash = hash(Core.get_last_block())
    new_block(proof, previous_hash)
  end

  #TODO WIP, implement consensus https://hackernoon.com/learn-blockchains-by-building-one-117428612f46#849f
  def register_node(address) do
     Core.init_blockchain()
     Core.add_node(address)
  end
end
