require 'test_helper'

class SelectedProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @selected_project = selected_projects(:one)
  end

  test "should get index" do
    get selected_projects_url
    assert_response :success
  end

  test "should get new" do
    get new_selected_project_url
    assert_response :success
  end

  test "should create selected_project" do
    assert_difference('SelectedProject.count') do
      post selected_projects_url, params: { selected_project: { project_id: @selected_project.project_id } }
    end

    assert_redirected_to selected_project_url(SelectedProject.last)
  end

  test "should show selected_project" do
    get selected_project_url(@selected_project)
    assert_response :success
  end

  test "should get edit" do
    get edit_selected_project_url(@selected_project)
    assert_response :success
  end

  test "should update selected_project" do
    patch selected_project_url(@selected_project), params: { selected_project: { project_id: @selected_project.project_id } }
    assert_redirected_to selected_project_url(@selected_project)
  end

  test "should destroy selected_project" do
    assert_difference('SelectedProject.count', -1) do
      delete selected_project_url(@selected_project)
    end

    assert_redirected_to selected_projects_url
  end
end
