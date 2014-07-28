defmodule CdrGen.PhoneNumberTest do
  use ExUnit.Case

  test "get a random phone number" do
    assert CdrGen.PhoneNumber.get_random
  end

end

