defmodule Rexerbug.OptionsTest do
  use ExUnit.Case

  alias Rexerbug.Options, as: Opts

  describe "parse/1" do
    test "parses defaults" do
      opts = Opts.parse([])

      assert opts[:msgs] == 10
      assert opts[:time] == 60_000
      assert opts[:procs] == :all
    end

    test "converts count to msgs" do
      opts = Opts.parse(count: 42)

      assert opts[:msgs] == 42
      refute opts[:count]
    end

    test "converts timeout to time" do
      opts = Opts.parse(timeout: 100)

      assert opts[:time] == 100
      refute opts[:timeout]
    end

    test "converts pids to procs" do
      opts = Opts.parse(pids: [1, 2, 3])

      assert opts[:procs] == [1, 2, 3]
      refute opts[:pids]
    end

    test "merges rexerbug opts with rexbug opts" do
      opts = Opts.parse(count: 42, print_depth: 99)

      assert opts[:msgs] == 42
      assert opts[:print_depth] == 99
    end

    test "prefers rexerbug opts" do
      opts =
        Opts.parse(
          count: 42,
          msgs: 10,
          timeout: 1_000,
          time: 60_000,
          pids: [1, 2, 3],
          procs: :all
        )

      assert opts[:msgs] == 42
      assert opts[:time] == 1_000
      assert opts[:procs] == [1, 2, 3]
    end
  end
end
