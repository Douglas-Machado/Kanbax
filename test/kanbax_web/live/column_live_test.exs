defmodule KanbaxWeb.ColumnLiveTest do
  use KanbaxWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Kanbax.Kanban

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp fixture(:column) do
    {:ok, column} = Kanban.create_column(@create_attrs)
    column
  end

  defp create_column(_) do
    column = fixture(:column)
    %{column: column}
  end

  describe "Index" do
    setup [:create_column]

    test "lists all columns", %{conn: conn, column: column} do
      {:ok, _index_live, html} = live(conn, Routes.column_index_path(conn, :index))

      assert html =~ "Listing Columns"
      assert html =~ column.name
    end

    test "saves new column", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.column_index_path(conn, :index))

      assert index_live |> element("a", "New Column") |> render_click() =~
               "New Column"

      assert_patch(index_live, Routes.column_index_path(conn, :new))

      assert index_live
             |> form("#column-form", column: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#column-form", column: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.column_index_path(conn, :index))

      assert html =~ "Column created successfully"
      assert html =~ "some name"
    end

    test "updates column in listing", %{conn: conn, column: column} do
      {:ok, index_live, _html} = live(conn, Routes.column_index_path(conn, :index))

      assert index_live |> element("#column-#{column.id} a", "Edit") |> render_click() =~
               "Edit Column"

      assert_patch(index_live, Routes.column_index_path(conn, :edit, column))

      assert index_live
             |> form("#column-form", column: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#column-form", column: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.column_index_path(conn, :index))

      assert html =~ "Column updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes column in listing", %{conn: conn, column: column} do
      {:ok, index_live, _html} = live(conn, Routes.column_index_path(conn, :index))

      assert index_live |> element("#column-#{column.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#column-#{column.id}")
    end
  end

  describe "Show" do
    setup [:create_column]

    test "displays column", %{conn: conn, column: column} do
      {:ok, _show_live, html} = live(conn, Routes.column_show_path(conn, :show, column))

      assert html =~ "Show Column"
      assert html =~ column.name
    end

    test "updates column within modal", %{conn: conn, column: column} do
      {:ok, show_live, _html} = live(conn, Routes.column_show_path(conn, :show, column))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Column"

      assert_patch(show_live, Routes.column_show_path(conn, :edit, column))

      assert show_live
             |> form("#column-form", column: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#column-form", column: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.column_show_path(conn, :show, column))

      assert html =~ "Column updated successfully"
      assert html =~ "some updated name"
    end
  end
end
