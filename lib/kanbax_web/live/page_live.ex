defmodule KanbaxWeb.PageLive do
  use KanbaxWeb, :live_view
  alias Kanbax.Kanban

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{}, status: list_status(), tasks: list_tasks())}
  end

  @impl true
  def handle_event(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Tarefa")
    |> assign(:task, Kanban.get_task!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Kanban.get_task!(id)
    {:ok, _} = Kanban.delete_task(task)

    {:noreply, assign(socket, :tasks, list_tasks())}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not KanbaxWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end

  defp list_status do
    Kanban.list_status()
  end

  defp list_tasks do
    Kanban.list_tasks()
  end
end
