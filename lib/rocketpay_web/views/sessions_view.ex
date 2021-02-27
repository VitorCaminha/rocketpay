defmodule RocketpayWeb.SessionsView do
  def render("login.json", %{token: token}) do
    %{
      message: "User logged in",
      token: token
    }
  end
end
