defmodule RexerbugTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  describe "start/2" do
    test "passes trace pattern to Rexbug" do
      pattern = "Map.new/0 :: stack"
      expect(RexbugMock, :start, fn ^pattern, _ -> {100, 42} end)

      assert {_, _} = Rexerbug.trace(pattern)
    end

    test "passes options to Rexbug" do
      opts = [time: 1_000]
      expect(RexbugMock, :start, fn _, ^opts -> {100, 42} end)
      assert {_, _} = Rexerbug.trace("Map.new/0 :: stack", opts)
    end
  end

  describe "rexbug/0" do
    test "returns configured rexbug client" do
      assert Rexerbug.rexbug() == RexbugMock
    end
  end
end
