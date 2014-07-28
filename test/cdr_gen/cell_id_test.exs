defmodule Cdrgen.CellIdTest do
  use ExUnit.Case

  test "returns a cell id properly" do
    assert CdrGen.CellId.get_random
  end
end
