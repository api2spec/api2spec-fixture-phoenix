defmodule Api2specFixturePhoenix.PostController do
  use Phoenix.Controller, formats: [:json]

  def index(conn, _params) do
    posts = [
      %{id: 1, user_id: 1, title: "First Post", body: "Hello world"},
      %{id: 2, user_id: 1, title: "Second Post", body: "Another post"}
    ]
    json(conn, posts)
  end

  def show(conn, %{"id" => id}) do
    json(conn, %{id: String.to_integer(id), user_id: 1, title: "Sample Post", body: "Post body"})
  end

  def create(conn, params) do
    post = Map.merge(%{id: 1}, params)
    conn |> put_status(:created) |> json(post)
  end

  def user_posts(conn, %{"user_id" => user_id}) do
    posts = [%{id: 1, user_id: String.to_integer(user_id), title: "User Post", body: "Content"}]
    json(conn, posts)
  end
end
