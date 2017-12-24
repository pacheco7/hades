defmodule Hades.MentorshipsTest do
  use Hades.DataCase

  alias Hades.Mentorships

  describe "mentors" do
    alias Hades.Mentorships.Mentor

    @valid_attrs %{is_active: true, max_mentorships: 2, skill_areas: ["Backend"]}
    @update_attrs %{is_active: false, max_mentorships: 3, skill_areas: ["Backend", "DevOps"]}
    @invalid_attrs %{is_active: nil, max_mentorships: nil, skill_areas: []}
    @invalid_skill_areas_attrs %{is_active: false, max_mentorships: 3, skill_areas: ["Bad", "Skills"]}

    def mentor_fixture(attrs \\ %{}) do
      {:ok, mentor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Mentorships.create_mentor()

      mentor
    end

    test "list_mentors/0 returns all mentors" do
      mentor = mentor_fixture()
      assert Mentorships.list_mentors() == [mentor]
    end

    test "get_mentor!/1 returns the mentor with given id" do
      mentor = mentor_fixture()
      assert Mentorships.get_mentor!(mentor.id) == mentor
    end

    test "create_mentor/1 with valid data creates a mentor" do
      assert {:ok, %Mentor{} = mentor} = Mentorships.create_mentor(@valid_attrs)
      assert mentor.is_active == true
      assert mentor.max_mentorships == 2
      assert mentor.skill_areas == ["Backend"]
    end

    test "create_mentor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mentorships.create_mentor(@invalid_attrs)
    end

    test "create_mentor/1 with invalid skill areas returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mentorships.create_mentor(@invalid_skill_areas_attrs)
    end

    test "update_mentor/2 with valid data updates the mentor" do
      mentor = mentor_fixture()
      assert {:ok, mentor} = Mentorships.update_mentor(mentor, @update_attrs)
      assert %Mentor{} = mentor
      assert mentor.is_active == false
      assert mentor.max_mentorships == 3
      assert mentor.skill_areas == ["Backend", "DevOps"]
    end

    test "update_mentor/2 with invalid data returns error changeset" do
      mentor = mentor_fixture()
      assert {:error, %Ecto.Changeset{}} = Mentorships.update_mentor(mentor, @invalid_attrs)
      assert mentor == Mentorships.get_mentor!(mentor.id)
    end
  end
end