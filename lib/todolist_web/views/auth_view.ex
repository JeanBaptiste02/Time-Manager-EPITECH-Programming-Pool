defmodule TodolistWeb.AuthView do
  use TodolistWeb, :view
  alias TodolistWeb.AuthView

  def render("show.json", %{success: success, message: message}),
    # Vous pouvez personnaliser la réponse JSON ici
    do: %{
      success: success,
      message: message
    }

  def render("errors.json", %{errors: errors}),
    # Vous pouvez personnaliser la réponse JSON ici
    do: %{
      success: false,
      errors: errors
    }

  def render("error.json", %{error: error}),
    # Vous pouvez personnaliser la réponse JSON ici
    do: %{
      success: false,
      error: error
    }

  def render("login.json", %{success: success, token: token, message: message}),
    # Vous pouvez personnaliser la réponse JSON ici
    do: %{
      success: success,
      token: token,
      message: message
    }

  def render("data.json", %{data: data}), do: %{success: true, data: data}
end
