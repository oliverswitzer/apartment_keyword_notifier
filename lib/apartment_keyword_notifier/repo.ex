defmodule ApartmentKeywordNotifier.Repo do
  use Ecto.Repo,
    otp_app: :apartment_keyword_notifier,
    adapter: Ecto.Adapters.Postgres
end
