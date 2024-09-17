defmodule Clutterstack.Repo do
  use Ecto.Repo,
    otp_app: :clutterstack,
    adapter: Ecto.Adapters.SQLite3
end
