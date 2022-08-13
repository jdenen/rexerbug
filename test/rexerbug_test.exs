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

    test "parses {mod, fun, args} with binary args" do
      expect(RexbugMock, :start, fn ~s|String.split("abc", "b") :: return;stack|, _ -> @return end)

      Rexerbug.trace({String, :split, ["abc", "b"]})
    end

    test "parses {mod, fun, args} argument" do
      args = [[1, "a", :b, ["a", :b, 3], %{"a" => 1}, %{b: 2}, {1, 2}, [key: :word]]]

      expected =
        ~s|List.first([1, "a", :b, ["a", :b, 3], %{"a" => 1}, %{b: 2}, {1, 2}, [key: :word]]) :: return;stack|

      expect(RexbugMock, :start, fn ^expected, _ -> @return end)

      Rexerbug.trace({List, :first, args})
    end
  end

  describe "rexbug/0" do
    test "returns configured rexbug client" do
      assert Rexerbug.rexbug() == RexbugMock
    end
  end
end
