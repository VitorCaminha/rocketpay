defmodule Rocketpay.Sessions.Login do
  alias Rocketpay.{Repo, User, Guardian}

  def call(%{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, "User not found!"}
      user -> verify_password(user, password)
    end
  end

  defp verify_password(%User{id: id, password_hash: password_hash}, password) do
    case Pbkdf2.verify_pass(password, password_hash) do
      false -> {:error, "password does not match!"}
      true -> generate_token(id)
    end
  end

  defp generate_token(id) do
    {:ok, token, _claims} = Guardian.encode_and_sign(id)

    {:ok, %{token: token}}
  end
end
