defmodule App.VerifyHeader do
  @moduledoc """
  Use this plug to verify a token contained in the header.
  """
  import Plug.Conn


  def init(opts \\ %{}) do
    Enum.into(opts, %{})
  end

  def call(%Plug.Conn{assigns: %{user: _}} = conn, _),
  do: conn

  def call(conn, _),
  do: verify_token(conn, fetch_token(conn))


  defp verify_token(conn, nil), do: render_error conn
  defp verify_token(conn, ""), do: render_error conn

  defp verify_token(conn, token) do

    case App.Repo.get_by(App.Authorization, token: token) do
      nil ->
        render_error(conn)

      auth ->
        auth = App.Repo.preload(auth, :user)
        Plug.Conn.assign(conn, :user, auth.user)
    end
  end

  defp fetch_token(conn),
  do: strip_token(Plug.Conn.get_req_header(conn, "authorization"))

  defp strip_token(nil), do: nil
  defp strip_token([]), do: nil

  defp strip_token([token|_tail]),
  do: String.strip(token)

  defp render_error(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Poison.encode!(%{error: "Unauthenticated"}))
    |> halt
  end
end

