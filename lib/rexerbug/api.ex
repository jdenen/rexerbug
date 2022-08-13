defmodule Rexerbug.Api do
  @moduledoc """
  Callbacks that must be handled by a Rexbug implementation.
  """
  @callback start(Rexbug.trace_pattern(), Keyword.t()) :: Rexbug.rexbug_return()

  @spec rexbug() :: module
  def rexbug do
    Application.get_env(:rexerbug, :rexbug, Rexbug)
  end
end
