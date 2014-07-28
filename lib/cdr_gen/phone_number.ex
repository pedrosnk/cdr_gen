defmodule CdrGen.PhoneNumber do
  @moduledoc """
  Module responsile to generate and add phone numbers
  """
  import CdrGen.AgentStore

  @doc """
  returning a random phone number based on the phone number list that was created
  """
  def get_random do
    list = list __MODULE__, &generate_list/0
    position = rem round(:random.uniform * 1_000_000 + 1), Enum.count(list)
    Enum.at list, position
  end

  defp generate_list do
    {t1, t2, t3} = :erlang.now
    :random.seed t1, t2, t3
    Enum.map 1..501, fn(_) ->
      round :random.uniform * 100_000_000
    end
  end

end

