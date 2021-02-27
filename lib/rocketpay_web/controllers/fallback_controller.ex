defmodule  RocketpayWeb.FallbackController do
  use RocketpayWeb, :controller

  alias RocketpayWeb.ErrorView

  @behaviour Guardian.Plug.ErrorHandler

  @impl true
  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(RocketpayWeb.ErrorView)
    |> render("400.json", result: result)
  end

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("400.json", result: Atom.to_string(type))
  end
end
