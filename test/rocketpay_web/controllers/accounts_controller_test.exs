defmodule  RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.User

  describe "deposit/2" do
    setup %{conn: conn} do
      user_params = %{
        name: "Vitor Caminha",
        password: "123456",
        nickname: "vitorcaminha",
        email: "vitorcaminha@gmail.com",
        age: 25
      }

      Rocketpay.create_user(user_params)

      {:ok, %{token: token}} = Rocketpay.login(%{
        "email" => "vitorcaminha@gmail.com",
        "password" => "123456"
      })

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "when all params are valid, make the deposit", %{conn: conn} do
      params = %{"value" => "50.00"}

      response = conn
      |> post(Routes.accounts_path(conn, :deposit, params))
      |> json_response(:ok)

      assert %{
                "account" => %{"balance" => "50.00", "id" => _id},
                "message" => "Balance changed successfully"
              } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = %{"value" => "banana"}

      response = conn
      |> post(Routes.accounts_path(conn, :deposit, params))
      |> json_response(:bad_request)

      assert  response == %{"message" => "Invalid deposit value!"}
    end
  end

  describe "withdraw/2" do
    setup %{conn: conn} do
      user_params = %{
        name: "Vitor Caminha",
        password: "123456",
        nickname: "vitorcaminha",
        email: "vitorcaminha@gmail.com",
        age: 25
      }

      {:ok, %User{id: user_id}} = Rocketpay.create_user(user_params)

      Rocketpay.deposit(%{"value" => "50.00"}, user_id)

      {:ok, %{token: token}} = Rocketpay.login(%{
        "email" => "vitorcaminha@gmail.com",
        "password" => "123456"
      })

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "when all params are valid, make the withdraw", %{conn: conn} do
      params = %{"value" => "50.00"}

      response = conn
      |> post(Routes.accounts_path(conn, :withdraw, params))
      |> json_response(:ok)

      assert %{
                "account" => %{"balance" => "0.00", "id" => _id},
                "message" => "Balance changed successfully"
              } = response
    end

    test "when there is no balance, returns an error", %{conn: conn} do
      params = %{"value" => "60.00"}

      response = conn
      |> post(Routes.accounts_path(conn, :withdraw, params))
      |> json_response(:bad_request)

      assert %{"message" => %{"balance" => ["is invalid"]}} = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = %{"value" => "-10.00"}

      response = conn
      |> post(Routes.accounts_path(conn, :withdraw, params))
      |> json_response(:bad_request)

      assert  response == %{"message" => "Invalid withdraw value!"}
    end
  end

  describe "transaction/2" do
    setup %{conn: conn} do
      user_params = %{
        name: "Vitor Caminha",
        password: "123456",
        nickname: "vitorcaminha",
        email: "vitorcaminha@gmail.com",
        age: 25
      }

      {:ok, %User{id: user_id}} = Rocketpay.create_user(user_params)

      Rocketpay.deposit(%{"value" => "50.00"}, user_id)

      {:ok, %{token: token}} = Rocketpay.login(%{
        "email" => "vitorcaminha@gmail.com",
        "password" => "123456"
      })

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "when all params are valid, make the transaction", %{conn: conn} do
      params = %{"value" => "50.00"}

      response = conn
      |> post(Routes.accounts_path(conn, :transaction, params))
      |> json_response(:ok)

      assert %{
                "account" => %{"balance" => "0.00", "id" => _id},
                "message" => "Balance changed successfully"
              } = response
    end

    test "when there is no balance, returns an error", %{conn: conn} do
      params = %{"value" => "60.00"}

      response = conn
      |> post(Routes.accounts_path(conn, :transaction, params))
      |> json_response(:bad_request)

      assert %{"message" => %{"balance" => ["is invalid"]}} = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = %{"value" => "-10.00"}

      response = conn
      |> post(Routes.accounts_path(conn, :transaction, params))
      |> json_response(:bad_request)

      assert  response == %{"message" => "Invalid withdraw value!"}
    end
  end
end
