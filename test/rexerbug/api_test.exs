defmodule Rexerbug.ApiTest do
  use ExUnit.Case

  describe "rexbug/0" do
    test "returns configured rexbug client" do
      assert Rexerbug.Api.rexbug() == RexbugMock
    end
  end
end
