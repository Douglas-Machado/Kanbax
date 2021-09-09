defmodule KanbaxWeb.ColumnLive.FormComponent do
  use KanbaxWeb, :live_component

  alias Kanbax.Kanban

  @impl true
  def update(%{column: column} = assigns, socket) do
    changeset = Kanban.change_column(column)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"column" => column_params}, socket) do
    changeset =
      socket.assigns.column
      |> Kanban.change_column(column_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"column" => column_params}, socket) do
    save_column(socket, socket.assigns.action, column_params)
  end

  defp save_column(socket, :edit, column_params) do
    case Kanban.update_column(socket.assigns.column, column_params) do
      {:ok, _column} ->
        {:noreply,
         socket
         |> put_flash(:info, "Column updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_column(socket, :new, column_params) do
    case Kanban.create_column(column_params) do
      {:ok, _column} ->
        {:noreply,
         socket
         |> put_flash(:info, "Column created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
