defmodule KanbaxWeb.TaskLive.FormComponent do
  use KanbaxWeb, :live_component

  alias Kanbax.Kanban

  @impl true
  def update(%{task: task} = assigns, socket) do
    changeset = Kanban.change_task(task)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset =
      socket.assigns.task
      |> Kanban.change_task(task_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.action, task_params)
  end

  defp save_task(socket, :edit, task_params) do
    case Kanban.update_task(socket.assigns.task, task_params) do
      {:ok, _task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Alteração salva com sucesso")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_task(socket, :new, task_params) do
    IO.inspect(task_params)
    case Kanban.create_task(task_params) do
      {:ok, _task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tarefa criada com sucesso")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
