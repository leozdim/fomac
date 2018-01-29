require 'test_helper'

class ProjectAssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_assignment = project_assignments(:one)
  end

  test "should get index" do
    get project_assignments_url
    assert_response :success
  end

  test "should get new" do
    get new_project_assignment_url
    assert_response :success
  end

  test "should create project_assignment" do
    assert_difference('ProjectAssignment.count') do
      post project_assignments_url, params: { project_assignment: { project_id: @project_assignment.project_id, user_id: @project_assignment.user_id } }
    end

    assert_redirected_to project_assignment_url(ProjectAssignment.last)
  end

  test "should show project_assignment" do
    get project_assignment_url(@project_assignment)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_assignment_url(@project_assignment)
    assert_response :success
  end

  test "should update project_assignment" do
    patch project_assignment_url(@project_assignment), params: { project_assignment: { project_id: @project_assignment.project_id, user_id: @project_assignment.user_id } }
    assert_redirected_to project_assignment_url(@project_assignment)
  end

  test "should destroy project_assignment" do
    assert_difference('ProjectAssignment.count', -1) do
      delete project_assignment_url(@project_assignment)
    end

    assert_redirected_to project_assignments_url
  end
end
