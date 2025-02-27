#!/usr/bin/env elixir

# Log the initial state before Mix starts
IO.puts("Initial Environment:")
IO.puts("------------------")
IO.puts("Current dir: #{File.cwd!()}")
IO.puts("Script path: #{__ENV__.file}")
IO.puts("Code paths: ")
:code.get_path() |> Enum.sort() |> Enum.each(&IO.puts/1)

# Try to replicate Mix.CLI initialization
IO.puts("\nStarting Mix:")
IO.puts("-------------")
Mix.start()
Mix.Local.append_archives()
Mix.Local.append_paths()

IO.puts("\nMix state after initialization:")
IO.puts("------------------------------")
IO.puts("Mix.Project.deps_paths: #{inspect(Mix.Project.deps_paths())}")
IO.puts("Mix.Project.build_path: #{inspect(Mix.Project.build_path())}")
IO.puts("Mix paths: #{inspect(Mix.Project.build_paths())}")

IO.puts("\nHex state:")
IO.puts("-----------")
try do
  hex_module = Mix.Local.path_for(:archives) |> Path.join("hex-*") |> Path.wildcard() |> List.first()
  IO.puts("Hex archive path: #{inspect(hex_module)}")
rescue
  e -> IO.puts("Error accessing Hex: #{inspect(e)}")
end
