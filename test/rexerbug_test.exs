defmodule RexerbugTest do
  use ExUnit.Case

  import Mox

  @return {100, 42}

  setup :verify_on_exit!

  describe "trace/2" do
    test "passes arguments to Rexbug" do
      pattern = "Map.new/0 :: stack"

      expect(RexbugMock, :start, fn ^pattern, _opts -> @return end)
      Rexerbug.trace(pattern)
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

    test "parses {mod, fun, args} argument" do
      args = [[1, "a", :b, ["a", :b, 3], %{"a" => 1}, %{b: 2}, {1, 2}, [key: :word]]]

      expected =
        ~s|List.first([1, "a", :b, ["a", :b, 3], %{"a" => 1}, %{b: 2}, {1, 2}, [key: :word]]) :: return;stack|

      expect(RexbugMock, :start, fn ^expected, _ -> @return end)

      Rexerbug.trace({List, :first, args})
    end

    test "parses module argument" do
      expect(RexbugMock, :start, fn "Map :: return;stack", _ -> @return end)
      Rexerbug.trace(Map)

      expect(RexbugMock, :start, fn ":ets :: return;stack", _ -> @return end)
      Rexerbug.trace(:ets)
    end
  end

  describe "monitor/2" do
    test "traces :send and :receive events for a given process" do
      pid = self()

      expect(RexbugMock, :start, fn [:send, :receive], opts ->
        assert [^pid] = Keyword.get(opts, :procs)
      end)

      Rexerbug.monitor(pid)
    end

    test "passes options through to Rexbug" do
      pid = self()

      expect(RexbugMock, :start, fn _, opts ->
        assert opts[:time] == 1_000
        assert opts[:cookie] == "hello there"
        @return
      end)

      Rexerbug.monitor(pid, timeout: 1_000, cookie: "hello there")
    end
  end
end
