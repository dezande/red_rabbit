defmodule RedRabbit.Repo do
  use Ecto.Repo,
    otp_app: :red_rabbit,
    adapter: Ecto.Adapters.Postgres
end
