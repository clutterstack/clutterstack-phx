defmodule ClutterstackWeb.RedirectPlug do
  import Plug.Conn

  def init(_opts) do
    endpoint = Application.get_env(:clutterstack, ClutterstackWeb.Endpoint)
    %{
      canonical_host: Keyword.get(endpoint, :canonical_host, "clutterstack.com"),
      redirect_from_hosts: Keyword.get(endpoint, :redirect_from_hosts, [])
    }
  end

  def call(conn, opts) do
    cond do
      conn.host in opts.redirect_from_hosts ->
        redirect_to_canonical(conn, opts.canonical_host)

      true ->
        # Path-based redirect logic
        case :ets.lookup(:redirects, conn.request_path) do
          [{old, new}] ->
            IO.inspect([{old, new}], label: "looked up a redirect")
            redirect_to_path(conn, new)

          [] ->
            conn
        end
    end
  end

  defp redirect_to_canonical(conn, canonical_host) do
    path_with_query = build_path_with_query(conn)
    redirect_url = "https://#{canonical_host}#{path_with_query}"

    conn
    |> put_status(301)
    |> put_resp_header("location", redirect_url)
    |> send_resp(301, "Moved permanently")
    |> halt()
  end

  defp redirect_to_path(conn, new_path) do
    conn
    |> put_status(301)
    |> put_resp_header("location", "/" <> new_path)
    |> send_resp(301, "Moved permanently")
    |> halt()
  end

  defp build_path_with_query(conn) do
    case conn.query_string do
      "" -> conn.request_path
      query -> "#{conn.request_path}?#{query}"
    end
  end
end
