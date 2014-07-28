defmodule CdrGen.AgentStore do
  @moduledoc """
  This module will encapsulate mostly common functions
  used by the cdr fields in order to store, and retrieve for the Agents
  """

  @doc """
  returning a list of items to
  """
  def list agent_name, generator do
    case Agent.start_link(fn -> [] end, name: agent_name) do
      {:ok, _pid} ->
        phones = generator.()
        Agent.update agent_name, fn(_) -> phones end
        phones
      {:error, _reason_pid} ->
        Agent.get agent_name, &(&1)
    end
  end

end

