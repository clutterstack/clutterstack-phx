defmodule Clutterstack.RedirectTable do
  # Makes this module act like a Supervisor child
  use Agent

  @table_name :redirects

  def start_link(_) do
    # start_link/2 is required for supervisor children
    Agent.start_link(fn ->
      create_table()
    end, name: __MODULE__)
  end

  def get_redirect(path) do
    case :ets.lookup(@table_name, path) do
      [{^path, destination}] -> {:ok, destination}
      [] -> {:error, :not_found}
    end
  end

  defp create_table do
    :ets.new(@table_name, [:named_table, :set, :public])
    load_initial_redirects()
    @table_name
  end

  defp load_initial_redirects do
    # Load from database, file, etc
    redirects = Clutterstack.Entries.read_redirects()
    |> IO.inspect(label: "loading redirects from table")
    # Enum.each(redirects, &:ets.insert(@table_name, &1))
    # ACTUALLY let's add entries with and without trailing slashes
    Enum.each(redirects, fn {redirect_from, new_path} ->
      # :ets.insert(@table_name, {redirect_from, new_path})
      :ets.insert(@table_name, {String.replace_trailing(redirect_from, "/", ""), new_path})
      :ets.insert(@table_name, {String.replace_trailing(redirect_from, "/", "")<>"/", new_path})

    end)
  end

end
