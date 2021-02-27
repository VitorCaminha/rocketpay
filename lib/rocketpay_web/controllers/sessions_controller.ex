defmodule  RocketpayWeb.SessionsController do
  use RocketpayWeb, :controller

  action_fallback RocketpayWeb.FallbackController

  def login(conn, params) do
    with {:ok, %{token: token}} <- Rocketpay.login(params) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token)
    end
  end
end
