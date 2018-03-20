defmodule Block do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:index, :proof, :transactions, :previous_hash, :timestamp]
end
