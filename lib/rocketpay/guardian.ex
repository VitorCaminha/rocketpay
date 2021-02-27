defmodule Rocketpay.Guardian do
  use Guardian, otp_app: :rocketpay

  def subject_for_token(id, _claims) do
    {:ok, id}
  end

  def resource_from_claims(%{"sub" => id}) do
    {:ok, id}
  end
  def resource_from_claims(_) do
    {:error, %{result: "JWT Token not provided."}}
  end
end
