defmodule KanbaxWeb.StatusLive.FormComponent do
  use KanbaxWeb, :live_component

  alias Kanbax.Kanban

  @impl true
  def update(%{status: status} = assigns, socket) do
    changeset = Kanban.change_status(status)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"status" => status_params}, socket) do
    changeset =
      socket.assigns.status
      |> Kanban.change_status(status_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"status" => status_params}, socket) do
    save_status(socket, socket.assigns.action, status_params)
  end

  defp save_status(socket, :edit, status_params) do
    case Kanban.update_status(socket.assigns.status, status_params) do
      {:ok, _status} ->
        {:noreply,
         socket
         |> put_flash(:info, "Status updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_status(socket, :new, status_params) do
    case Kanban.create_status(status_params) do
      {:ok, _status} ->
        {:noreply,
         socket
         |> put_flash(:info, "Status created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
