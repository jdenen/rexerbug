defmodule Rexerbug.Api do
  @moduledoc """
  Callbacks that must be handled by a Rexbug implementation.
  """
  @callback start(Rexbug.trace_pattern(), Keyword.t()) :: Rexbug.rexbug_return()

  @doc """
  Returns the configured Rexbug implementation. By default: Rexbug.
  """
  @spec rexbug() :: module
  def rexbug do
    Application.get_env(:rexerbug, :rexbug, Rexbug)
  end
end
