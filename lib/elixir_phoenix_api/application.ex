defmodule ElixirPhoenixApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirPhoenixApiWeb.Telemetry,
      ElixirPhoenixApi.Repo,
      {DNSCluster, query: Application.get_env(:elixir_phoenix_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirPhoenixApi.PubSub},
      # Start a worker by calling: ElixirPhoenixApi.Worker.start_link(arg)
      # {ElixirPhoenixApi.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirPhoenixApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirPhoenixApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirPhoenixApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
