defmodule Blockchain.Application do
  @moduledoc false

  use Application

  @transaction_cache_name :transactions
  @blockchain_cache_name :blockchain
  @nodes_cache_name :nodes

  def get_blockchain_cache_name, do: @blockchain_cache_name

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Bargain.Worker.start_link(arg)
      # {Bargain.Worker, arg},
      worker(Cachex, [get_blockchain_cache_name(), []])
#      supervisor(Blockchain.Repo, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blockchain.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
