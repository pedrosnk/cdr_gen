defmodule CdrGen.AgentStore do
  @moduledoc """
  This module will encapsulate mostly common functions
  used by the cdr fields in order to store, and retrieve for the Agents
  """

  @doc """
  returning a list of items to
  """
  def list agent_name, generator do
    case Agent.start_link(fn -> [] end, name: :phone_numbers) do
      {:ok, _pid} ->
        phones = generator.()
        Agent.update :phone_numbers, fn(_) -> phones end
        phones
      {:error, _reason_pid} ->
        Agent.get :phone_numbers,  &(&1)
    end
  end

end

