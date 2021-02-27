defmodule  RocketpayWeb.AccountsController do
  use RocketpayWeb, :controller

  alias Rocketpay.Account
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  action_fallback RocketpayWeb.FallbackController

  def deposit(conn, params) do
    id = Guardian.Plug.current_resource(conn)

    with {:ok, %Account{} = account} <- Rocketpay.deposit(params, id) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def withdraw(conn, params) do
    id = Guardian.Plug.current_resource(conn)

    with {:ok, %Account{} = account} <- Rocketpay.withdraw(params, id) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def transaction(conn, params) do
    id = Guardian.Plug.current_resource(conn)

    with {:ok, %TransactionResponse{} = transaction} <- Rocketpay.transaction(params, id) do
      conn
      |> put_status(:ok)
      |> render("transaction.json", transaction: transaction)
    end
  end
end
