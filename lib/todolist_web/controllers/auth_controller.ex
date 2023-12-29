defmodule TodolistWeb.AuthController do
  alias JOSE.JWT
  alias ElixirLS.LanguageServer.Dialyzer.Utils
  use TodolistWeb, :controller
  alias Todolist.Accounts.User
  alias Todolist.Accounts
  alias TodolistWeb.Utils
  alias TodolistWeb.JwtToken

  def login(conn, %{"username" => username, "password" => password}) do
    with %User{} = user <- Accounts.get_user_by_username!(username),
         true <- Bcrypt.verify_pass(password, user.password) do
      signer =
        Joken.Signer.create(
          "HS256",
          "UkbLwxJuuRrBtXCwgQlk4gdmzlPRe4WyvPAhTWbByU1J5+Al5vsCuNNZeggSnXfg"
        )

      current_time = :os.system_time(:millisecond)
      expiration_time = current_time + 30 * 24 * 3600 * 1000
      csrf_token = generate_csrf_token()

      extra_claims = %{
        csrf_token: csrf_token,
        user_id: user.id,
        exp: expiration_time,
        role: user.role
      }

      {:ok, token, _claims} = JwtToken.generate_and_sign(extra_claims, signer)
      IO.inspect("#token #{token}")

      conn =
        conn
        |> put_resp_cookie(
          "jwt_token",
          token,
          http_only: true,
          max_age: 30 * 24 * 3600
        )

      conn
      |> render("login.json", %{success: true, message: "login successful", token: token})
    else
      _ ->
        conn
        |> render("error.json", %{error: Utils.invalid_credentials()})
    end
  end

  def generate_csrf_token do
    :crypto.strong_rand_bytes(50)
    |> Base.encode16()
    |> String.slice(0, 50)
  end

  def register(conn, params) do
    case Accounts.create_user(params) do
      {:ok, _user} ->
        conn |> render("show.json", %{success: true, message: "Registration successful"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})

      nill ->
        conn |> render("error.json", %{error: Utils.internal_server_error()})
    end
  end

  def logout(conn, _params) do
    conn = Plug.Conn.delete_resp_cookie(conn, "jwt_token")

    conn
    |> json(%{message: "Déconnexion réussie"})
  end

  def get(conn, _params) do
    IO.inspect(conn)
    conn |> render("data.json", %{data: conn.assigns.current_user})
  end
end
