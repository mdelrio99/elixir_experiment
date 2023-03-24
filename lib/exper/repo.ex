defmodule Exper.Repo do
  use Ecto.Repo,
    otp_app: :exper,
    adapter: Ecto.Adapters.Postgres
end
