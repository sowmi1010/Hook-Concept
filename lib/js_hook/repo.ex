defmodule JsHook.Repo do
  use Ecto.Repo,
    otp_app: :js_hook,
    adapter: Ecto.Adapters.Postgres
end
