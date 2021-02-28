defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi

  alias Rocketpay.Account

  def call(%{"value" => value}, user_id, operation) do
    operation_name = account_operation_name(operation)

    Multi.new()
    |> Multi.run(operation_name, fn repo, _changes -> get_account(repo, user_id) end)
    |> Multi.run(operation, fn repo, changes ->
        account = Map.get(changes, operation_name)

        update_balance(repo, account, value, operation)
      end)
  end

  defp get_account(repo, user_id) do
    case repo.get_by(Account, user_id: user_id) do
      nil -> {:error, "Account not found!"}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value, operation) do
    account
    |> operation(value, operation)
    |> update_account(repo, account)
  end

  defp operation(%Account{balance: balance}, value, operation) do
    value
    |> Decimal.cast()
    |> check_if_negative()
    |> handle_cast(balance, operation)
  end

  defp check_if_negative({:ok, value}) do
    case Decimal.compare(value, 0) do
      :gt -> {:ok, value}
      _ -> :error
    end
  end
  defp check_if_negative(:error), do: :error

  defp handle_cast({:ok, value}, balance, :deposit), do: Decimal.add(balance, value)
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, value)
  defp handle_cast(:error, _balance, operation), do: {:error, "Invalid #{Atom.to_string(operation)} value!"}

  defp update_account({:error, _reason} = error, _repo, _account), do: error
  defp update_account(value, repo, account) do
    params = %{balance: value}

    account
    |> Account.changeset(params)
    |> repo.update()
  end

  defp account_operation_name(operation) do
    "account_#{Atom.to_string(operation)}"
    |> String.to_atom()
  end
end
