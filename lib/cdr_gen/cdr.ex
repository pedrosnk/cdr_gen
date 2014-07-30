defmodule CdrGen.Cdr do
  @moduledoc """
  Model of the CDR
  """
  defstruct "incoming-call": "", "outcome-call": "",
      "time-started": 1, "time-ended":  2,
      "cell-id": "", "cdr-id": ""

end

