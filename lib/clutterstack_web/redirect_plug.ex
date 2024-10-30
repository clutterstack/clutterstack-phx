defmodule ClutterstackWeb.RedirectPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    IO.inspect(conn, label: "inside redirectplug")
    IO.inspect(:ets.lookup(:redirects, conn.request_path), label: "the ets lookup")
    case :ets.lookup(:redirects, conn.request_path) do
      [{old, new}] -> IO.inspect([{old, new}], label: "looked up a redirect")
        conn
        |> put_status(301)
        |> put_resp_header("location", "/" <> new)
        |> send_resp(301, "Moved permanently")
        |> halt() # don't keep going through plugs
      [] -> conn
    end

  end

end
