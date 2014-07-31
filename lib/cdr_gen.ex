defmodule CdrGen do
  @moduledoc """
  CdrGen is the main Class of the application. It is to interface with other
  module of hte application to call its functionality
  """

  @riak_ips ['172.30.1.118','172.30.1.17','172.30.1.109']
  @pool_size 18
  @cdr_generation_procs 8
  #@riak_ips ['172.30.1.118']

  @doc """
  Function responsible to generate a single
  CDR and returning it
  """
  def generate_cdr do
    time_generated_cdr_begin = Timex.Date.from {2013, 06, 01}
    time_generated_cdr_end = Timex.Date.from {2013, 07, 01}
    cdr = %CdrGen.Cdr{ "incoming-call": CdrGen.PhoneNumber.get_random,
                       "outcome-call": CdrGen.PhoneNumber.get_random,
                       "cell-id": CdrGen.CellId.get_random }
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
    generate_cdr # dont known Y but is necessary to generate phone list
    {max_range, remainder} = divide_equals_parts options[:size], @cdr_generation_procs
    Enum.map(1..@cdr_generation_procs, fn(_) -> tasks_generate_cdr(max_range) end )
      |> Enum.concat([tasks_generate_cdr(remainder)])
      |> Enum.flat_map(&Task.await(&1, 100_000_000))
  end

  def small_profile cdrs, riak_ip do
    t_start = Timex.Time.now
    insert_list cdrs, riak_ip
    t_end = Timex.Time.now
    IO.puts Timex.Time.diff(t_end, t_start, :secs)
  end

  @doc """
  Insert a single cdr inside the database
  """
  def insert_into_database cdr do
    {:ok, pid} = Riex.Connection.start_link Enum.at(@riak_ips, 0), 8087
    {:ok, json} = JSEX.encode cdr
    r_obj = Riex.Object.create bucket: "cdr", data: json
    Riex.put pid, r_obj
  end

  @doc """
  insert cdrs into a dataa
  """
  def insert_by_chunks cdrs do
    chuck_size = Enum.count(cdrs) / @pool_size |> Float.floor |> round
    cdrs |> Enum.chunk(chuck_size)
         |> Enum.with_index
         |> Enum.each(fn(chunk_with_index) ->
           {chunk, index} = chunk_with_index
           riak_ip_index = rem index, Enum.count(@riak_ips)
           riak_ip = Enum.at @riak_ips, riak_ip_index
           spawn_link CdrGen, :small_profile, [chunk, riak_ip]
         end )
  end

  @doc """
  Insert a list of cdr directly into a riak instance by creating a connection by a given ip
  """
  def insert_list cdrs, riak_ip do
    {:ok, pid} = Riex.Connection.start_link riak_ip, 8087
    {t1, t2, t3} = :erlang.now
    :random.seed t1, t2, t3
    temp_id = round( :random.uniform * 1_000)
    IO.puts "###{temp_id} start inserting at #{riak_ip}"
    Enum.each cdrs, fn(cdr) ->
      r_obj = Riex.Object.create bucket: "cdr", data: cdr
      Riex.put pid, r_obj
    end
    IO.puts "###{temp_id} finish inserting at #{riak_ip}"
  end

  @doc  """
  Responsible for create a given number of cdrs and insert by chunk
  """
  def start_insert cdrs_size do
    cdrs = generate_cdrs %{size: cdrs_size}
    insert_by_chunks cdrs
  end

  def divide_equals_parts total, num do
    max_range = div total, num
    remainder = rem total, num
    {max_range, remainder}
  end

  defp cdr_to_json cdr do
    "{\"incoming-call\": \"#{Map.get(cdr, :"incoming-call")}\", " <>
    "\"outcome-call\": \"#{Map.get(cdr, :"outcome-call")}\", " <>
    "\"time-started\": #{Map.get(cdr, :"time-started")}, " <>
    "\"time-ended\": #{Map.get(cdr, :"time-ended")}, " <>
    "\"cell-id\": \"#{Map.get(cdr, :"cell-id")}\" }"
  end

  defp tasks_generate_cdr size do
    Task.async fn ->
      if size == 0 do
        []
      else
        Enum.map 1..size, fn(_) -> generate_cdr |> cdr_to_json end
      end
    end
  end


end

