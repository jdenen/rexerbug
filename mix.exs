defmodule Rexerbug.MixProject do
  use Mix.Project

  def project do
    [
      app: :rexerbug,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rexbug, "~> 1.0"},
      {:dialyxir, "~> 1.2", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
