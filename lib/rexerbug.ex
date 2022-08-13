defmodule Rexerbug do
  @doc false
  def rexbug do
    Application.get_env(:rexerbug, :rexbug, Rexbug)
  end
end
