defmodule RexerbugTest do
  use ExUnit.Case

  import Mox

  @return {100, 42}

  setup :verify_on_exit!

  describe "start/2" do
    test "passes arguments to Rexbug" do
      pattern = "Map.new/0 :: stack"
      opts = [time: 1_000]

      expect(RexbugMock, :start, fn ^pattern, ^opts -> @return end)
      Rexerbug.trace(pattern, opts)
    end

    test "defaults return value to 'return;stack'" do
      expected_pattern = "Map.new/0 :: return;stack"

      expect(RexbugMock, :start, fn ^expected_pattern, _ -> @return end)
      Rexerbug.trace("Map.new/0")
    end

    test "parses function argument" do
      expect(RexbugMock, :start, fn "String.split/2 :: return;stack", _ -> @return end)
      Rexerbug.trace(&String.split/2)
    end

    test "parses {mod, fun} argument" do
      expect(RexbugMock, :start, fn "String.split/_ :: return;stack", _ -> @return end)
      Rexerbug.trace({String, :split})
    end
  end

  describe "rexbug/0" do
    test "returns configured rexbug client" do
      assert Rexerbug.rexbug() == RexbugMock
    end
  end
end
