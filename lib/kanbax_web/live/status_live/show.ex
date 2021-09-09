defmodule KanbaxWeb.StatusLive.Show do
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
     |> assign(:status, Kanban.get_status!(id))}
  end

  defp page_title(:show), do: "Show Status"
  defp page_title(:edit), do: "Edit Status"
end
