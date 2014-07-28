defmodule CdrGen do
  @moduledoc """
  CdrGen is the main Class of the application. It is to interface with other
  modules of hte application to call its functionality
  """

  @doc """
  Function responsible to generate a single
  CDR and returning it
  """
  def generate_cdr do
    time_generated_cdr_begin = Timex.Date.from {2013, 06, 01}
    time_generated_cdr_end = Timex.Date.from {2013, 07, 01}
    cdr = %CdrGen.Cdr{ incoming_call: CdrGen.PhoneNumber.get_random, outcome_call: CdrGen.PhoneNumber.get_random }
    Map.merge cdr, CdrGen.CallTime.get_random_time(time_generated_cdr_begin, time_generated_cdr_end)
  end

  @doc """
  Generate cdrs based on a number of cdrs it can be passed into options
  # Example
    # It will generate 20 cdrs
    CdrGen.generate_cdrs %{ size: 20 }
  """
  def generate_cdrs options do
    options = Map.merge %{ size: 10 }, options
    Enum.map 1..options[:size], fn(_) -> generate_cdr end
  end

  def small_profile size do
    t_start = Timex.Time.now
    CdrGen.generate_cdrs %{ size: size }
    t_end = Timex.Time.now
    Timex.Time.diff t_end, t_start, :secs
  end


end

