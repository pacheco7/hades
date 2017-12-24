defmodule HadesWeb.MentorControllerTest do
  use HadesWeb.ConnCase

  alias Hades.Mentorships
  alias Hades.Mentorships.Mentor

  @create_attrs %{is_active: true, max_mentorships: 2, skill_areas: ["Backend", "Frontend"]}
  @update_attrs %{is_active: false, max_mentorships: 3, skill_areas: ["Backend", "Frontend", "DevOps"]}
  @invalid_attrs %{is_active: nil, max_mentorships: nil, skill_areas: ["Bad input","Not a thing"]}
  @invalid_skill_areas_attrs %{is_active: false, max_mentorships: 3, skill_areas: ["Bad", "Skills"]}

  def fixture(:mentor) do
    {:ok, mentor} = Mentorships.create_mentor(@create_attrs)
    mentor
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all mentors", %{conn: conn} do
      conn = get conn, mentor_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create mentor" do
    test "renders mentor when data is valid", %{conn: conn} do
      conn = post conn, mentor_path(conn, :create), mentor: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, mentor_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_active" => true,
        "max_mentorships" => 2,
        "skill_areas" => ["Backend", "Frontend"]}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, mentor_path(conn, :create), mentor: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when skill areas is invalid", %{conn: conn} do
      conn = post conn, mentor_path(conn, :create), mentor: @invalid_skill_areas_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update mentor" do
    setup [:create_mentor]

    test "renders mentor when data is valid", %{conn: conn, mentor: %Mentor{id: id} = mentor} do
      conn = put conn, mentor_path(conn, :update, mentor), mentor: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, mentor_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_active" => false,
        "max_mentorships" => 3,
        "skill_areas" => ["Backend", "Frontend", "DevOps"]}
    end

    test "renders errors when data is invalid", %{conn: conn, mentor: mentor} do
      conn = put conn, mentor_path(conn, :update, mentor), mentor: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when skill areas is invalid", %{conn: conn, mentor: mentor} do
      conn = put conn, mentor_path(conn, :update, mentor), mentor: @invalid_skill_areas_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_mentor(_) do
    mentor = fixture(:mentor)
    {:ok, mentor: mentor}
  end
end