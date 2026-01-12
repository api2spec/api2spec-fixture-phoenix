defmodule Api2specFixturePhoenix.UserController do
  use Phoenix.Controller, formats: [:json]

  def index(conn, _params) do
    users = [
      %{id: 1, name: "Alice", email: "alice@example.com"},
      %{id: 2, name: "Bob", email: "bob@example.com"}
    ]
    json(conn, users)
  end

  def show(conn, %{"id" => id}) do
    json(conn, %{id: String.to_integer(id), name: "Sample User", email: "user@example.com"})
  end

  def create(conn, params) do
    user = Map.merge(%{id: 1}, params)
    conn |> put_status(:created) |> json(user)
  end

  def update(conn, %{"id" => id} = params) do
    user = Map.merge(%{id: String.to_integer(id)}, params)
    json(conn, user)
  end

  def delete(conn, _params) do
    send_resp(conn, :no_content, "")
  end
end
