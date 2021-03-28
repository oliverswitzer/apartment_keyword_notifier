# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :apartment_keyword_notifier,
  ecto_repos: [ApartmentKeywordNotifier.Repo]

# Configures the endpoint
config :apartment_keyword_notifier, ApartmentKeywordNotifierWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JmMZmFx0Ycm5Q2021+AkTS7Lwov614a2ODpjPx6jpcLc6vUWe8mv8uRxl+zNJr/x",
  render_errors: [view: ApartmentKeywordNotifierWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ApartmentKeywordNotifier.PubSub,
  live_view: [signing_salt: "CznGipSC"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

if Mix.env() != :prod do
  config :git_hooks,
    auto_install: true,
    verbose: true,
    hooks: [
      pre_commit: [
        tasks: [
          {:cmd, "mix format --check-formatted"}
        ]
      ],
      pre_push: [
        verbose: false,
        tasks: [
          {:cmd, "mix dialyzer"},
          {:cmd, "mix test"},
          {:cmd, "echo 'success!'"}
        ]
      ]
    ]
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
