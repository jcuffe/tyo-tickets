defmodule TyoTickets.Repo do
  use Ecto.Repo,
    otp_app: :tyo_tickets,
    adapter: Ecto.Adapters.Postgres
end
