defmodule RocketpayWeb.SessionsViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias RocketpayWeb.SessionsView

  test "renders login.json" do
    user_params = %{
      name: "Vitor Caminha",
      password: "123456",
      nickname: "vitorcaminha",
      email: "vitorcaminha@gmail.com",
      age: 25
    }

    Rocketpay.create_user(user_params)

    params = %{
      "email" => "vitorcaminha@gmail.com",
      "password" => "123456",
    }

    {:ok, %{token: token}} = Rocketpay.login(params)

    response = render(SessionsView, "login.json", token: token)

    expected_response = %{
      message: "User logged in",
      token: token
    }

    assert expected_response == response
  end
end
