defmodule RocketpayWeb.AccountsViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.AccountsView
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  test "renders update.json" do
    params = %{
      name: "Vitor Caminha",
      password: "123456",
      nickname: "vitorcaminha",
      email: "vitorcaminha@gmail.com",
      age: 25
    }

    {:ok, %User{account: %Account{id: account_id, balance: balance} = account}} =
      Rocketpay.create_user(params)

    response = render(AccountsView, "update.json", account: account)

    expected_response = %{
      message: "Balance changed successfully",
      account: %{
        id: account_id,
        balance: balance
      }
    }

    assert expected_response == response
  end

  test "renders transaction.json" do
    params = %{
      name: "Vitor Caminha",
      password: "123456",
      nickname: "vitorcaminha",
      email: "vitorcaminha@gmail.com",
      age: 25
    }

    {:ok, %User{account: %Account{id: account_id, balance: balance} = account}} =
      Rocketpay.create_user(params)

    response = render(AccountsView, "transaction.json", transaction: %TransactionResponse{
      to_account: account,
      from_account: account
    })

    expected_response = %{
      message: "Transaction done successfully",
      transaction: %{
        from_account: %{
          id: account_id,
          balance: balance,
        },
        to_account: %{
          id: account_id,
          balance: balance,
        }
      }
    }

    assert expected_response == response
  end
end
