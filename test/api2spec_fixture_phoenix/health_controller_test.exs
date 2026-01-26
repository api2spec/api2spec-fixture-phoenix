defmodule Api2specFixturePhoenix.HealthControllerTest do
  use Api2specFixturePhoenix.ConnCase

  describe "GET /health" do
    test "returns health status with ok", %{conn: conn} do
      conn = get(conn, "/health")

      assert json_response(conn, 200) == %{"status" => "ok", "version" => "0.1.0"}
    end
  end

  describe "GET /health/ready" do
    test "returns ready status", %{conn: conn} do
      conn = get(conn, "/health/ready")

      assert json_response(conn, 200) == %{"status" => "ready", "version" => "0.1.0"}
    end
  end
end
