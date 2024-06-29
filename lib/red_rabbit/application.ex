defmodule RedRabbit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RedRabbitWeb.Telemetry,
      RedRabbit.Repo,
      {DNSCluster, query: Application.get_env(:red_rabbit, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RedRabbit.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: RedRabbit.Finch},
      # Start a worker by calling: RedRabbit.Worker.start_link(arg)
      # {RedRabbit.Worker, arg},
      # Start to serve requests, typically the last entry
      RedRabbitWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RedRabbit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RedRabbitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
