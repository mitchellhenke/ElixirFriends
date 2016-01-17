ExUnit.start

Mix.Task.run "ecto.create", ~w(-r ElixirFriends.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r ElixirFriends.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(ElixirFriends.Repo)

