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
    %Model.Cdr{ incoming_call: PhoneNumber.get_random, outcome_call: PhoneNumber.get_random }
  end

  @doc """
  Generate cdrs based on a number of cdrs it can be passed into options
  # Example
    # It will generate 20 cdrs
    CdrGen.generate_cdrs %{size: 20}
  """
  def generate_cdrs options do
    options = Map.merge %{ size: 10 }, options
    Enum.map 1..options[:size], fn(_) -> generate_cdr end
  end

end
