# Blockchain

 - A small Blockchain (not ready) in Elixir for Learn purposes (WIP)

### Register
```Elixir
iex> Blockchain.register_node(self())
```

### Create new transaction
```Elixir
iex> Blockchain.new_transaction "sender-address", "marcos-address", 100
```

### Mine
```Elixir
iex> Blockchain.mine
```


##### Ref:

- [learn by building](https://hackernoon.com/learn-blockchains-by-building-one-117428612f46)
- [bitcoin white paper](https://bitcoin.org/bitcoin.pdf)