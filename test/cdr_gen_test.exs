defmodule CdrGenTest do
  use ExUnit.Case

  @cdr_fields [:incoming_call, :outcome_call, :time_started, :time_ended, :cell_id, :cdr_id]

  test "generate a single cdr" do
    cdr = CdrGen.generate_cdr
    Enum.each @cdr_fields, fn(x) ->
      assert Map.has_key?(cdr, x)
    end
  end

  test "timestamp generated must be greater than 0" do
    cdr = CdrGen.generate_cdr
    assert (cdr.time_ended - cdr.time_started) > 0
  end

  test "generate many given cdrs" do
    cdrs_size = CdrGen.generate_cdrs(%{size: 50})
      |> Enum.uniq
      |> Enum.count
    assert cdrs_size == 50
  end

  test "inserts generated cdr into a riak database" do
    cdr = CdrGen.generate_cdr
    {msg, _} = CdrGen.insert_into_database cdr
    assert msg == :ok
  end
end

