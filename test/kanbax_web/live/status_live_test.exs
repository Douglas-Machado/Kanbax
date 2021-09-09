defmodule KanbaxWeb.StatusLiveTest do
  use KanbaxWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Kanbax.Kanban

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  defp fixture(:status) do
    {:ok, status} = Kanban.create_status(@create_attrs)
    status
  end

  defp create_status(_) do
    status = fixture(:status)
    %{status: status}
  end

  describe "Index" do
    setup [:create_status]

    test "lists all status", %{conn: conn, status: status} do
      {:ok, _index_live, html} = live(conn, Routes.status_index_path(conn, :index))

      assert html =~ "Listing Status"
      assert html =~ status.title
    end

    test "saves new status", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.status_index_path(conn, :index))

      assert index_live |> element("a", "New Status") |> render_click() =~
               "New Status"

      assert_patch(index_live, Routes.status_index_path(conn, :new))

      assert index_live
             |> form("#status-form", status: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#status-form", status: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.status_index_path(conn, :index))

      assert html =~ "Status created successfully"
      assert html =~ "some title"
    end

    test "updates status in listing", %{conn: conn, status: status} do
      {:ok, index_live, _html} = live(conn, Routes.status_index_path(conn, :index))

      assert index_live |> element("#status-#{status.id} a", "Edit") |> render_click() =~
               "Edit Status"

      assert_patch(index_live, Routes.status_index_path(conn, :edit, status))

      assert index_live
             |> form("#status-form", status: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#status-form", status: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.status_index_path(conn, :index))

      assert html =~ "Status updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes status in listing", %{conn: conn, status: status} do
      {:ok, index_live, _html} = live(conn, Routes.status_index_path(conn, :index))

      assert index_live |> element("#status-#{status.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#status-#{status.id}")
    end
  end

  describe "Show" do
    setup [:create_status]

    test "displays status", %{conn: conn, status: status} do
      {:ok, _show_live, html} = live(conn, Routes.status_show_path(conn, :show, status))

      assert html =~ "Show Status"
      assert html =~ status.title
    end

    test "updates status within modal", %{conn: conn, status: status} do
      {:ok, show_live, _html} = live(conn, Routes.status_show_path(conn, :show, status))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Status"

      assert_patch(show_live, Routes.status_show_path(conn, :edit, status))

      assert show_live
             |> form("#status-form", status: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#status-form", status: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.status_show_path(conn, :show, status))

      assert html =~ "Status updated successfully"
      assert html =~ "some updated title"
    end
  end
end
