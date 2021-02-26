defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{User, Repo}
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Vitor Caminha",
        password: "123456",
        nickname: "vitorcaminha",
        email: "vitorcaminha@gmail.com",
        age: 25
      }

      {:ok, %User{id: user_id}} = Create.call(params)

      user = Repo.get(User, user_id)

      assert %User{name: "Vitor Caminha", age: 25, id: ^user_id} = user
    end

    test "when there are invalid params, returns an error" do
      params = %{
        name: "Vitor Caminha",
        nickname: "vitorcaminha",
        email: "vitorcaminha@gmail.com",
        age: 15
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
