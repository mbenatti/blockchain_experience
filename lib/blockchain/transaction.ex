defmodule Transaction do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:sender, :recipient, :amount]
end
