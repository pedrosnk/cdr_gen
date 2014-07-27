defmodule CdrGen do

  def generate_cdr do
    %Model.Cdr{}
  end

  def generate_cdrs options do
    options = Map.merge %{ size: 10 }, options
    Enum.map 1..options[:size], fn(x) -> %Model.Cdr{} end
  end

  defp random_cdr_model do

  end

end
