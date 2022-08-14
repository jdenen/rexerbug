defmodule Rexerbug.OptionsTest do
  use ExUnit.Case

  alias Rexerbug.Options, as: Opts

  @new_old count: :msgs,
           timeout: :time,
           pids: :procs,
           connect: :target,
           arity?: :arity,
           buffer?: :buffered,
           discard?: :discard

  describe "parse/1" do
    test "parses defaults" do
      opts = Opts.parse([])

      assert opts[:msgs] == 10
      assert opts[:time] == 60_000
      assert opts[:procs] == :all
      assert opts[:target] == Node.self()
      assert opts[:arity] == false
      assert opts[:buffered] == false
      assert opts[:discard] == false
    end

    test "converts new keys to old" do
      Enum.each(@new_old, fn {new, old} ->
        opts = Opts.parse([{new, :foo}])
        assert opts[old] == :foo
        refute opts[new]
      end)
    end

    test "merges rexerbug opts with rexbug opts" do
      opts = Opts.parse(count: 42, print_depth: 99)

      assert opts[:msgs] == 42
      assert opts[:print_depth] == 99
    end

    test "prefers rexerbug opts" do
      opts = Opts.parse(count: 42, msgs: 10)
      assert opts[:msgs] == 42
    end
  end
end
