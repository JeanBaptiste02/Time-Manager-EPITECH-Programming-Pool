defmodule TodolistWeb.JwtAuthPlug do
  import Plug.Conn
  alias Todolist.Accounts
  alias Todolist.Accounts.User
  def init(opts), do: opts

  def call(conn, _) do
    bearer = get_req_header(conn, "authorization") |> List.first()

    if bearer == nil do
      conn |> put_status(401) |> halt
    else
      token = bearer |> String.split(" ") |> List.last()

      signer =
        Joken.Signer.create(
          "HS256",
          "UkbLwxJuuRrBtXCwgQlk4gdmzlPRe4WyvPAhTWbByU1J5+Al5vsCuNNZeggSnXfg"
        )

      IO.inspect("je suis la")

      with {:ok, %{"user_id" => user_id}} <-
             TodolistWeb.JwtToken.verify_and_validate(token, signer),
           %User{} = user <- Accounts.get_user(user_id) do
        conn |> assign(:current_user, user)
      else
        {:error, _reason} -> conn |> put_status(401) |> halt
        _ -> conn |> put_status(401) |> halt
      end
    end
  end
end
