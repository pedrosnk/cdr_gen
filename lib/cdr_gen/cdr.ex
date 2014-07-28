defmodule CdrGen.Cdr do
  @moduledoc """
  Model of the CDR
  """
  defstruct incoming_call: "", outcome_call: "",
      time_started: 1, time_ended:  2,
      cell_id: '', cdr_id: ''

end

