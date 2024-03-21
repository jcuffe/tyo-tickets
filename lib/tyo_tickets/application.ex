defmodule TyoTickets.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TyoTicketsWeb.Telemetry,
      TyoTickets.Repo,
      {DNSCluster, query: Application.get_env(:tyo_tickets, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TyoTickets.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TyoTickets.Finch},
      # Start a worker by calling: TyoTickets.Worker.start_link(arg)
      # {TyoTickets.Worker, arg},
      # Start to serve requests, typically the last entry
      TyoTicketsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TyoTickets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TyoTicketsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
