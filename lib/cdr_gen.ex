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
    cdr = %CdrGen.Cdr{ incoming_call: CdrGen.PhoneNumber.get_random, 
                       outcome_call: CdrGen.PhoneNumber.get_random,
                       cell_id: CdrGen.CellId.get_random }
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

  def small_profile cdrs do
    t_start = Timex.Time.now
    insert_list cdrs
    t_end = Timex.Time.now
    IO.puts Timex.Time.diff(t_end, t_start, :secs)
  end

  @doc """
  Insert a single cdr inside the database
  """
  def insert_into_database cdr do
    {:ok, pid} = Riex.Connection.start_link '172.30.1.118', 8087
    {:ok, json} = JSEX.encode cdr
    r_obj = Riex.Object.create bucket: "cdr", data: json
    Riex.put pid, r_obj
  end

  def insert_by_chunks cdrs do
    chuck_size = Enum.count(cdrs) / 5 |> Float.floor |> round
    cdrs |> Enum.chunk(chuck_size) 
         |> Enum.each(fn(c) -> spawn_link CdrGen, :small_profile, [c] end)
  end

  def insert_list cdrs do
    {:ok, pid} = Riex.Connection.start_link '172.30.1.118', 8087
    Enum.each cdrs, fn(cdr) ->
      {:ok, json} = JSEX.encode cdr
      r_obj = Riex.Object.create bucket: "cdr", data: json
      Riex.put pid, r_obj
    end
  end

end

