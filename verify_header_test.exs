defmodule App.VerifyHeaderTest do
  use App.ConnCase

  test "it can verify tokens from header and adds user to assigns", %{conn: conn} do

    user = App.TestData.Users.mazyod
    auth = App.User.identity_auth(user)

    conn = conn
    |> put_req_header("authorization", auth.token)
    |> App.VerifyHeader.call(%{})

    assert conn.assigns.user == user
  end

  test "it skips verification if user is assigned", %{conn: conn} do

    conn = conn |> assign(:user, %{})
    result = conn |> App.VerifyHeader.call(%{})

    assert result == conn
  end

  test "it returns unauthorized if token is invalid", %{conn: conn} do

    conn = conn
    |> put_req_header("authorization", "blahblahblah")
    |> App.VerifyHeader.call(%{})

    assert json_response(conn, 401) == %{"error" => "Unauthenticated"}
  end

  test "it returns unauthorized if no token nor user present", %{conn: conn} do
    conn = App.VerifyHeader.call conn, %{}
    assert json_response(conn, 401) == %{"error" => "Unauthenticated"}
  end
end

