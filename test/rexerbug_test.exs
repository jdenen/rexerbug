defmodule RexerbugTest do
  use ExUnit.Case
  doctest Rexerbug

  test "greets the world" do
    assert Rexerbug.hello() == :world
  end
end
