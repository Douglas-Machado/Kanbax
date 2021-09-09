defmodule KanbaxWeb.ColumnLive.Index do
  use KanbaxWeb, :live_view

  alias Kanbax.Kanban
  alias Kanbax.Kanban.Column

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :columns, list_columns())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Column")
    |> assign(:column, Kanban.get_column!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Column")
    |> assign(:column, %Column{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Columns")
    |> assign(:column, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    column = Kanban.get_column!(id)
    {:ok, _} = Kanban.delete_column(column)

    {:noreply, assign(socket, :columns, list_columns())}
  end

  defp list_columns do
    Kanban.list_columns()
  end
end
