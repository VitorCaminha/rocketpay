defmodule Rocketpay do
  alias Rocketpay.Users.Create, as: UserCreate

  alias Rocketpay.Sessions.Login

  alias Rocketpay.Accounts.{Deposit, Transaction, Withdraw}

  defdelegate create_user(params), to: UserCreate, as: :call

  defdelegate login(params), to: Login, as: :call

  defdelegate deposit(params, user_id), to: Deposit, as: :call
  defdelegate withdraw(params, user_id), to: Withdraw, as: :call
  defdelegate transaction(params, user_id), to: Transaction, as: :call
end
