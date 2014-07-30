defmodule CdrGen.CallTime do
  @moduledoc """
  responsable to generate the times of a determined call
  """

  @doc """
  get a random time period withing a given interval formated in
  the unix epoch.
  It returns a Map with the values for each

  ## Example

    CallTime.get_random_time date1, date2
    # %{ time_ended: 1407178338, time_started: 1407758019 }
  """
  def get_random_time start_date, end_date do
    secs_begin = Timex.Date.to_secs start_date
    secs_end = Timex.Date.to_secs end_date
    time_started = random_in_interval secs_begin, secs_end
    duration = random_in_interval 10, 600 # 10 seconds to 10 minutes
    %{ "time-started": time_started, "time-ended": time_started + duration  }
  end

  defp random_in_interval min, max do
    round (:random.uniform  * (max - min + 1)) + min
  end

end

