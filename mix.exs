defmodule CdrGen.Mixfile do
  use Mix.Project

  def project do
    [app: :cdr_gen,
     version: "0.0.1",
     elixir: "~> 0.14.3",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: []]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [ {:riak_pb, github: 'basho/riak_pb', override: true, compile: './rebar get-deps && ./rebar compile deps_dir=../'},
      {:riakc, github: 'basho/riak-erlang-client'},
      { :timex, "~> 0.10.1" }]
  end
end
