defmodule  RocketpayWeb.UsersControllerTest do
  use RocketpayWeb.ConnCase, async: true

  describe "create/2" do
    test "when all params are valid, create an user", %{conn: conn} do
      params = %{
        "name" => "Vitor Caminha",
        "password" => "123456",
        "nickname" => "vitorcaminha",
        "email" => "vitorcaminha@gmail.com",
        "age" => 25
      }

      response = conn
      |> post(Routes.users_path(conn, :create, params))
      |> json_response(:created)

      assert %{
                "user" => %{
                  "name" => "Vitor Caminha",
                  "nickname" => "vitorcaminha",
                  "account" => %{
                    "balance" => "0.00",
                    "id" => _account_id
                  },
                  "id" => _id
                },
                "message" => "User created"
              } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = %{
        "name" => "Vitor Caminha",
        "password" => "123456",
        "nickname" => "vitorcaminha",
        "age" => 25
      }

      response = conn
      |> post(Routes.users_path(conn, :create, params))
      |> json_response(:bad_request)

      assert  response == %{"message" => %{"email" => ["can't be blank"]}}
    end
  end
end
