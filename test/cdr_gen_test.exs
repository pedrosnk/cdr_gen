defmodule CdrGenTest do
  use ExUnit.Case

  @cdr_fields [:"incoming-call", :"outcome-call", :"time-started", 
    :"time-ended", :"cell-id", :"cdr-id"]

  test "generate a single cdr" do
    cdr = CdrGen.generate_cdr
    Enum.each @cdr_fields, fn(x) ->
      assert Map.has_key?(cdr, x)
    end
  end

  test "timestamp generated must be greater than 0" do
    cdr = CdrGen.generate_cdr
    assert (Map.get(cdr, :"time-ended") - Map.get(cdr, :"time-started")) > 0
  end

  test "generate many given cdrs" do
    cdrs_size = CdrGen.generate_cdrs(%{size: 50})
      |> Enum.uniq
      |> Enum.count
    assert cdrs_size == 50
  end

  test "inserts generated cdr into a riak database" do
    cdr = CdrGen.generate_cdr
    o = CdrGen.insert_into_database cdr
    assert o
  end

  test "isnert generated cdrs into a riak database by chunks" do
    # test if will execute witout errors
    cdrs = CdrGen.generate_cdrs %{size: 10}
    CdrGen.insert_by_chunks cdrs
  end
end

