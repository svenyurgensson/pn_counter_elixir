defmodule PnCounter.Mixfile do
  use Mix.Project

  def project do
    [ app: :pn_counter,
      version: "0.0.1",
      elixir: "~> 0.10.3",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
     mod: { PnCounter, [] },
     applications: [:cowboy]
    ]
  end

  defp deps do
    [
     { :cowboy, github: "extend/cowboy", tag: "0.8.6" }
    ]
  end
end
