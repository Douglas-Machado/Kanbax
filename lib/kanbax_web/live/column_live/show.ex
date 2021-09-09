defmodule KanbaxWeb.ColumnLive.Show do
  use KanbaxWeb, :live_view

  alias Kanbax.Kanban

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:column, Kanban.get_column!(id))}
  end

  defp page_title(:show), do: "Show Column"
  defp page_title(:edit), do: "Edit Column"
end
