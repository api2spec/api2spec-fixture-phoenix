defmodule Api2specFixturePhoenix.PostControllerTest do
  use Api2specFixturePhoenix.ConnCase

  describe "GET /posts" do
    test "returns list of posts", %{conn: conn} do
      conn = get(conn, "/posts")

      assert response = json_response(conn, 200)
      assert is_list(response)
      assert length(response) >= 1

      first_post = Enum.find(response, fn p -> p["id"] == 1 end)
      assert first_post["title"] == "First Post"
      assert first_post["body"] == "Hello world"
      assert first_post["user_id"] == 1
    end
  end

  describe "GET /posts/:id" do
    test "returns post when exists", %{conn: conn} do
      conn = get(conn, "/posts/1")

      assert response = json_response(conn, 200)
      assert response["id"] == 1
      assert response["title"] == "First Post"
      assert response["body"] == "Hello world"
      assert response["user_id"] == 1
    end

    test "returns 404 when post not found", %{conn: conn} do
      conn = get(conn, "/posts/999")

      assert response = json_response(conn, 404)
      assert response["error"] == "Post not found"
    end

    test "returns 400 for invalid post ID", %{conn: conn} do
      conn = get(conn, "/posts/invalid")

      assert response = json_response(conn, 400)
      assert response["error"] == "Invalid post ID"
    end
  end

  describe "POST /posts" do
    test "creates post with valid data", %{conn: conn} do
      params = %{post: %{title: "New Post", body: "Post content", user_id: 1}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/posts", params)

      assert response = json_response(conn, 201)
      assert response["id"] == 3
      assert response["title"] == "New Post"
      assert response["body"] == "Post content"
    end

    test "returns 400 with missing post key", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/posts", %{})

      assert response = json_response(conn, 400)
      assert response["errors"]["post"] == "is required"
    end

    test "returns 422 with missing title", %{conn: conn} do
      params = %{post: %{body: "Post content"}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/posts", params)

      assert response = json_response(conn, 422)
      assert response["errors"]["title"] == "is required"
    end

    test "returns 422 with missing body", %{conn: conn} do
      params = %{post: %{title: "Test Title"}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/posts", params)

      assert response = json_response(conn, 422)
      assert response["errors"]["body"] == "is required"
    end

    test "returns 422 with empty title and body", %{conn: conn} do
      params = %{post: %{title: "", body: ""}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/posts", params)

      assert response = json_response(conn, 422)
      assert response["errors"]["title"] == "is required"
      assert response["errors"]["body"] == "is required"
    end
  end

  describe "PUT /posts/:id" do
    test "updates post with valid data", %{conn: conn} do
      params = %{post: %{title: "Updated Post", body: "Updated content"}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put("/posts/1", params)

      assert response = json_response(conn, 200)
      assert response["id"] == 1
      assert response["title"] == "Updated Post"
      assert response["body"] == "Updated content"
    end

    test "returns 404 when post not found", %{conn: conn} do
      params = %{post: %{title: "Updated", body: "Updated content"}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put("/posts/999", params)

      assert response = json_response(conn, 404)
      assert response["error"] == "Post not found"
    end

    test "returns 400 for invalid post ID", %{conn: conn} do
      params = %{post: %{title: "Updated"}}

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put("/posts/invalid", params)

      assert response = json_response(conn, 400)
      assert response["error"] == "Invalid post ID"
    end
  end

  describe "DELETE /posts/:id" do
    test "deletes post and returns 204", %{conn: conn} do
      conn = delete(conn, "/posts/1")

      assert response(conn, 204)
    end

    test "returns 404 when post not found", %{conn: conn} do
      conn = delete(conn, "/posts/999")

      assert response = json_response(conn, 404)
      assert response["error"] == "Post not found"
    end

    test "returns 400 for invalid post ID", %{conn: conn} do
      conn = delete(conn, "/posts/invalid")

      assert response = json_response(conn, 400)
      assert response["error"] == "Invalid post ID"
    end
  end

  describe "GET /users/:user_id/posts" do
    test "returns posts for a user", %{conn: conn} do
      conn = get(conn, "/users/1/posts")

      assert response = json_response(conn, 200)
      assert is_list(response)
      assert length(response) >= 1

      Enum.each(response, fn post ->
        assert post["user_id"] == 1
      end)
    end

    test "returns empty list when user has no posts", %{conn: conn} do
      conn = get(conn, "/users/2/posts")

      assert response = json_response(conn, 200)
      assert is_list(response)
      # User 2 has no posts in our fixture data (all posts belong to user 1)
      assert length(response) == 0
    end

    test "returns 404 when user not found", %{conn: conn} do
      conn = get(conn, "/users/999/posts")

      assert response = json_response(conn, 404)
      assert response["error"] == "User not found"
    end

    test "returns 400 for invalid user ID", %{conn: conn} do
      conn = get(conn, "/users/invalid/posts")

      assert response = json_response(conn, 400)
      assert response["error"] == "Invalid user ID"
    end
  end
end
