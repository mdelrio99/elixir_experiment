defmodule Exper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ExperWeb.Telemetry,
      # Start the Ecto repository
      Exper.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Exper.PubSub},
      #name: Exper.PubSub
      # Start Finch
      {Finch, name: Exper.Finch},
      # Start the Endpoint (http/https)
      ExperWeb.Endpoint,
      # Start a worker by calling: Exper.Worker.start_link(arg)
      # {Exper.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exper.Supervisor]
    startResults = Supervisor.start_link(children, opts)

    CPU.internal_start("0")

    startResults
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExperWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
