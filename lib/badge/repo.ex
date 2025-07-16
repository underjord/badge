defmodule Badge.Repo do
  use Ecto.Repo,
    otp_app: :badge,
    adapter: Ecto.Adapters.SQLite3
end
