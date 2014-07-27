defmodule PhoneNumber do
  @moduledoc """
  Module responsile to generate and add phone numbers
  """

  @doc """
  returning a list of phones that can be used to generate a cdr record
  """
  def list_phones do
    case Agent.start_link(fn -> [] end, name: :phone_numbers) do
      {:ok, _pid} ->
        phones = create_phones_list
        Agent.update :phone_numbers, fn(_) -> phones end
        phones
      {:error, _reason_pid} ->
        Agent.get :phone_numbers,  &(&1)
    end
  end

  @doc """
  returning a random phone number based on the phone number list that was created
  """
  def get_random do
    list = list_phones
    position = rem round(:random.uniform * 1_000_000 + 1), Enum.count(list)
    Enum.at list, position
  end

  defp create_phones_list do
    {t1, t2, t3} = :erlang.now
    :random.seed t1, t2, t3
    Enum.map 1..200_000, fn(_) ->
      round :random.uniform * 100_000_000
    end
  end

end
