defmodule Rexerbug.Api do
  @moduledoc """
  Callbacks that must be handled by a Rexbug implementation.
  """
  @type pattern ::
          function
          | {module, function}
          | {module, function, list}
          | atom
          | Rexbug.trace_pattern()

  @callback start(pattern, Rexbug.options()) :: Rexbug.rexbug_return()

  def rexbug do
    Application.get_env(:rexerbug, :rexbug, Rexbug)
  end
end
