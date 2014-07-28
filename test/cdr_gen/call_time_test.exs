defmodule CdrGen.CallTimeTest do
  use ExUnit.Case

  test "should return a call start and end date in a given interval" do
    start_date = Timex.Date.from {2013, 04, 01}
    end_date = Timex.Date.from {2013, 05, 01}
    call_time = CdrGen.CallTime.get_random_time start_date, end_date
    assert call_time[:time_started] >= Timex.Date.to_secs(start_date)
    assert call_time[:time_started] <= Timex.Date.to_secs(end_date)
  end
end
