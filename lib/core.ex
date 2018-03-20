defmodule Blockchain.Core do
  
  alias Blockchain.Repo
  alias Blockchain.Application

  import Ecto.Query, only: [from: 2, last: 2]

  @transactions "transactions"
  @blockchain "blockchain"
  @nodes "nodes"

  # Blockchain

  def init_blockchain do
    blockchain = get_blockchain()
    if blockchain == nil || Enum.empty?(blockchain) do
      Cachex.del(Application.get_blockchain_cache_name(), @blockchain)
      Cachex.put(Application.get_blockchain_cache_name(), @blockchain, [])

      generate_genesis_block()
    end
  end

  defp generate_genesis_block() do
    %Block{
        index: 0,
        timestamp: NaiveDateTime.to_string(NaiveDateTime.utc_now),
        transactions: [],
        proof: 0,
        previous_hash: nil
    }
    |> add_block()
  end

  def get_blockchain do
    Cachex.get!(Application.get_blockchain_cache_name(), @blockchain)
  end

  def add_block(block) do
    if get_blockchain() == nil, do: init_blockchain # init the cache

    Cachex.get_and_update!(Application.get_blockchain_cache_name(), @blockchain, &(List.insert_at(&1, 0, block)))
  end

  def get_last_block do
    List.first(get_blockchain())
  end

  def get_next_block_index do
    get_last_block_index() + 1
  end

  def get_last_block_index do
    get_last_block().index
  end

  def get_last_block_hash do
    get_last_block().hash
  end

  def get_last_block_proof do
    get_last_block().proof
  end

  # Trasactions

  def get_transactions do
    Cachex.get!(Application.get_blockchain_cache_name(), @transactions)
  end

  def add_transaction(transaction) do
    if get_transactions() == nil, do: reset_transactions # init the cache

    Cachex.get_and_update!(Application.get_blockchain_cache_name(), @transactions, &(List.insert_at(&1, 0, transaction)))
  end
  
  def reset_transactions do
    Cachex.del(Application.get_blockchain_cache_name(), @transactions)
    Cachex.put(Application.get_blockchain_cache_name(), @transactions, [])
  end

  # Nodes

  def get_nodes do
    Cachex.get!(Application.get_blockchain_cache_name(), @nodes)
  end

  def add_node(blockchain_node) do
    if get_nodes() == nil, do: init_node_cache # init the cache

    Cachex.get_and_update!(Application.get_blockchain_cache_name(), @nodes, &(List.insert_at(&1, 0, blockchain_node)))
  end

  def init_node_cache do
    Cachex.del(Application.get_blockchain_cache_name(), @nodes)
    Cachex.put(Application.get_blockchain_cache_name(), @nodes, [])
  end
  
  def remove_node(blockchain_node) do
    Cachex.get_and_update(Application.get_blockchain_cache_name(), @nodes, &(List.delete(&1, blockchain_node)))
  end
end
