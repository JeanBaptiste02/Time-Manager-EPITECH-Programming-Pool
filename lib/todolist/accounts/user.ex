defmodule Todolist.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  # Spécifiez les champs que vous voulez encoder
  @derive {Jason.Encoder, only: [:id, :email, :username]}

  schema "users" do
    field(:email, :string)
    field(:username, :string)
    field(:password, :string)
    field(:role, :boolean)
    has_many(:clocks, Todolist.Accounts.Clock, foreign_key: :user_id)
    has_many(:workingtimes, Todolist.Accounts.Workingtime, foreign_key: :user_id2)
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role])
    |> validate_required([:username, :email, :password])
    |> validate_length(:username, min: 2, max: 20)
    |> validate_length(:password, min: 8, max: 30)
    |> unique_constraint([:username, :email])
    |> update_change(:email, fn email -> String.downcase(email) end)
    |> update_change(:username, &String.downcase(&1))
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password, Bcrypt.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
