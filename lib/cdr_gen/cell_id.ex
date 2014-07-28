defmodule CdrGen.CellId do
  @moduledoc """
  Module responsile to generate and add cell id field
  """
  import CdrGen.AgentStore

  @doc """
  returning a random cell id field based on a generated or given list
  """
  def get_random do
    list = list __MODULE__, &generate_list/0
    position = rem round(:random.uniform * 1_000_000 + 1), Enum.count(list)
    Enum.at list, position
  end

  defp generate_list do
    {t1, t2, t3} = :erlang.now
    :random.seed t1, t2, t3
    Enum.map 1..50, fn(_) ->
      number = round :random.uniform * 100_000
      "BR" <> to_string(number)
    end
  end

end

