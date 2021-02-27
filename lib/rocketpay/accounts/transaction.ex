defmodule Rocketpay.Accounts.Transaction do
  alias Ecto.Multi

  alias Rocketpay.Accounts.Operation
  alias Rocketpay.{Repo, User}
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  def call(%{"to" => to_nickname, "value" => value}, from_id) do
    Multi.new()
    |> Multi.merge(fn _changes -> Operation.call(%{"value" => value}, from_id, :withdraw) end)
    |> Multi.run(:get_id_from_nickname, fn repo, _changes -> get_id_from_nickname(repo, to_nickname, from_id) end)
    |> Multi.merge(fn %{get_id_from_nickname: %User{id: to_id}} -> Operation.call(%{"value" => value}, to_id, :deposit) end)
    |> run_transaction()
  end

  defp get_id_from_nickname(repo, to_nickname, from_id) do
    case repo.get_by(User, nickname: to_nickname) do
      nil -> {:error, "User with this nickname not found!"}
      user -> check_if_same_user(user, from_id)
    end
  end

  defp check_if_same_user(%User{id: id} = user, from_id) do
    case id == from_id do
      true -> {:error, "You can not make a transaction with yourself"}
      false -> {:ok, user}
    end
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{deposit: to_account, withdraw: from_account}} ->
        {:ok, TransactionResponse.build(from_account, to_account)}
    end
  end
end
