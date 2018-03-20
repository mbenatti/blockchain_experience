defmodule Blockchain.MixProject do
  use Mix.Project

  def project do
    [
      app: :blockchain_experience,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Blockchain.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
        {:ecto, "~> 2.1"},
        # Ref: https://github.com/ankhers/mongodb_ecto/commit/4f4092e734edba504eb9b56fef974157ad57f737 updated Sep 16, 2017
        {:mongodb_ecto, git: "https://github.com/ankhers/mongodb_ecto.git", ref: "4f4092e734edba504eb9b56fef974157ad57f737"},
        {:cachex, "~> 3.0"},
        {:jason, "~> 1.0"}
    ]
  end
end
