defmodule Badge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BadgeWeb.Telemetry,
      Badge.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:badge, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:badge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Badge.PubSub},
      # Start a worker by calling: Badge.Worker.start_link(arg)
      # {Badge.Worker, arg},
      # Start to serve requests, typically the last entry
      BadgeWeb.Endpoint
    ] ++ target_children()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Badge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  if Mix.target() == :host do
    defp target_children() do
      [
        # Children that only run on the host during development or test.
        # In general, prefer using `config/host.exs` for differences.
        #
        # Starts a worker by calling: Host.Worker.start_link(arg)
        # {Host.Worker, arg},
      ]
    end
  else
    defp target_children() do
      [
        # Children for all targets except host
        # Starts a worker by calling: Target.Worker.start_link(arg)
        # {Target.Worker, arg},
      ]
    end
  end

    # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BadgeWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
