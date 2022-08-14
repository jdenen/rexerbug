defmodule Rexerbug.MixProject do
  use Mix.Project

  def project do
    [
      app: :rexerbug,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Johnson Denen"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/jdenen/rexerbug"}
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
