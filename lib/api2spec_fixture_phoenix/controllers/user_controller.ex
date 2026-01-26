defmodule Api2specFixturePhoenix.UserController do
  use Phoenix.Controller, formats: [:json]

  # Simulated user storage for demo purposes
  @users %{
    1 => %{id: 1, name: "Alice", email: "alice@example.com"},
    2 => %{id: 2, name: "Bob", email: "bob@example.com"}
  }

  def index(conn, _params) do
    users = Map.values(@users)
    json(conn, users)
  end

  def show(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {int_id, ""} when int_id > 0 and int_id <= 2 ->
        json(conn, Map.get(@users, int_id))

      {_int_id, ""} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid user ID"})
    end
  end

  def create(conn, %{"user" => user_params}) do
    case validate_user(user_params) do
      :ok ->
        user = Map.merge(%{"id" => 3}, user_params)
        conn |> put_status(:created) |> json(user)

      {:error, errors} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors})
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{errors: %{user: "is required"}})
  end

  def update(conn, %{"id" => id} = params) do
    case Integer.parse(id) do
      {int_id, ""} when int_id > 0 and int_id <= 2 ->
        user_params = Map.get(params, "user", %{})
        user = Map.merge(%{"id" => int_id}, user_params)
        json(conn, user)

      {_int_id, ""} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid user ID"})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {int_id, ""} when int_id > 0 and int_id <= 2 ->
        send_resp(conn, :no_content, "")

      {_int_id, ""} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid user ID"})
    end
  end

  defp validate_user(params) do
    errors = %{}

    errors =
      if is_nil(params["name"]) or params["name"] == "" do
        Map.put(errors, :name, "is required")
      else
        errors
      end

    errors =
      if is_nil(params["email"]) or params["email"] == "" do
        Map.put(errors, :email, "is required")
      else
        errors
      end

    if map_size(errors) == 0, do: :ok, else: {:error, errors}
  end
end
