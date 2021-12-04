# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kanbax.Repo.insert!(%Kanbax.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Kanbax.Kanban.create_status(%{title: "To do"})
Kanbax.Kanban.create_status(%{title: "Working In Progress"})
Kanbax.Kanban.create_status(%{title: "Testing"})
Kanbax.Kanban.create_status(%{title: "Homologation"})
Kanbax.Kanban.create_status(%{title: "Ready to production"})
Kanbax.Kanban.create_status(%{title: "Cancelled"})
