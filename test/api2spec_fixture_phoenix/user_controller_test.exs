defmodule Api2specFixturePhoenix.UserControllerTest do
  use Api2specFixturePhoenix.ConnCase

  describe "GET /users" do
    test "returns list of users", %{conn: conn} do
      conn = get(conn, "/users")

      assert response = json_response(conn, 200)
      assert is_list(response)
      assert length(response) >= 1

      first_user = Enum.find(response, fn u -> u["id"] == 1 end)
      assert first_user["name"] == "Alice"
      assert first_user["email"] == "alice@example.com"
    end
  end

  describe "GET /users/:id" do
    test "returns user when exists", %{conn: conn} do
      conn = get(conn, "/users/1")

      assert response = json_response(conn, 200)
      assert response["id"] == 1
      assert response["name"] == "Alice"
      assert response["email"] == "alice@example.com"
    end

    test "returns 404 when user not found", %{conn: conn} do
      conn = get(conn, "/users/999")

      assert response = json_response(conn, 404)
      assert response["error"] == "User not found"
    end

    test "returns 400 for invalid user ID", %{conn: conn} do
      conn = get(conn, "/users/invalid")

      assert response = json_response(conn, 400)
      assert response["error"] == "Invalid user ID"
    end
  end

  describe "POST /users" do
    test "creates user with valid data", %{conn: conn} do
      params = %{user: %{name: "Charlie", email: "charlie@example.com"}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/users", params)

      assert response = json_response(conn, 201)
      assert response["id"] == 3
      assert response["name"] == "Charlie"
      assert response["email"] == "charlie@example.com"
    end

    test "returns 400 with missing user key", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/users", %{})

      assert response = json_response(conn, 400)
      assert response["errors"]["user"] == "is required"
    end

    test "returns 422 with missing name", %{conn: conn} do
      params = %{user: %{email: "test@example.com"}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/users", params)

      assert response = json_response(conn, 422)
      assert response["errors"]["name"] == "is required"
    end

    test "returns 422 with missing email", %{conn: conn} do
      params = %{user: %{name: "Test User"}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/users", params)

      assert response = json_response(conn, 422)
      assert response["errors"]["email"] == "is required"
    end

    test "returns 422 with empty name and email", %{conn: conn} do
      params = %{user: %{name: "", email: ""}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/users", params)

      assert response = json_response(conn, 422)
      assert response["errors"]["name"] == "is required"
      assert response["errors"]["email"] == "is required"
    end
  end

  describe "PUT /users/:id" do
    test "updates user with valid data", %{conn: conn} do
      params = %{user: %{name: "Alice Updated", email: "alice.updated@example.com"}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put("/users/1", params)

      assert response = json_response(conn, 200)
      assert response["id"] == 1
      assert response["name"] == "Alice Updated"
      assert response["email"] == "alice.updated@example.com"
    end

    test "returns 404 when user not found", %{conn: conn} do
      params = %{user: %{name: "Updated", email: "updated@example.com"}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put("/users/999", params)

      assert response = json_response(conn, 404)
      assert response["error"] == "User not found"
    end

    test "returns 400 for invalid user ID", %{conn: conn} do
      params = %{user: %{name: "Updated"}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put("/users/invalid", params)

      assert response = json_response(conn, 400)
      assert response["error"] == "Invalid user ID"
    end
  end

  describe "DELETE /users/:id" do
    test "deletes user and returns 204", %{conn: conn} do
      conn = delete(conn, "/users/1")

      assert response(conn, 204)
    end

    test "returns 404 when user not found", %{conn: conn} do
      conn = delete(conn, "/users/999")

      assert response = json_response(conn, 404)
      assert response["error"] == "User not found"
    end

    test "returns 400 for invalid user ID", %{conn: conn} do
      conn = delete(conn, "/users/invalid")

      assert response = json_response(conn, 400)
      assert response["error"] == "Invalid user ID"
    end
  end
end
