defmodule Api2specFixturePhoenix.PostController do
  use Phoenix.Controller, formats: [:json]

  # Simulated post storage for demo purposes
  @posts %{
    1 => %{id: 1, user_id: 1, title: "First Post", body: "Hello world"},
    2 => %{id: 2, user_id: 1, title: "Second Post", body: "Another post"}
  }

  def index(conn, _params) do
    posts = Map.values(@posts)
    json(conn, posts)
  end

  def show(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {int_id, ""} when int_id > 0 and int_id <= 2 ->
        json(conn, Map.get(@posts, int_id))

      {_int_id, ""} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Post not found"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid post ID"})
    end
  end

  def create(conn, %{"post" => post_params}) do
    case validate_post(post_params) do
      :ok ->
        post = Map.merge(%{"id" => 3}, post_params)
        conn |> put_status(:created) |> json(post)

      {:error, errors} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors})
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{errors: %{post: "is required"}})
  end

  def user_posts(conn, %{"user_id" => user_id}) do
    case Integer.parse(user_id) do
      {int_user_id, ""} when int_user_id > 0 and int_user_id <= 2 ->
        user_posts =
          @posts
          |> Map.values()
          |> Enum.filter(fn post -> post.user_id == int_user_id end)

        json(conn, user_posts)

      {_int_user_id, ""} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid user ID"})
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Integer.parse(id) do
      {int_id, ""} when int_id > 0 and int_id <= 2 ->
        post_params = Map.get(params, "post", %{})
        post = Map.merge(%{"id" => int_id}, post_params)
        json(conn, post)

      {_int_id, ""} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Post not found"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid post ID"})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {int_id, ""} when int_id > 0 and int_id <= 2 ->
        send_resp(conn, :no_content, "")

      {_int_id, ""} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Post not found"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid post ID"})
    end
  end

  defp validate_post(params) do
    errors = %{}

    errors =
      if is_nil(params["title"]) or params["title"] == "" do
        Map.put(errors, :title, "is required")
      else
        errors
      end

    errors =
      if is_nil(params["body"]) or params["body"] == "" do
        Map.put(errors, :body, "is required")
      else
        errors
      end

    if map_size(errors) == 0, do: :ok, else: {:error, errors}
  end
end
