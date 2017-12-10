require 'test_helper'

class ArtFormsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @art_form = art_forms(:one)
  end

  test "should get index" do
    get art_forms_url
    assert_response :success
  end

  test "should get new" do
    get new_art_form_url
    assert_response :success
  end

  test "should create art_form" do
    assert_difference('ArtForm.count') do
      post art_forms_url, params: { art_form: { active: @art_form.active, name: @art_form.name } }
    end

    assert_redirected_to art_form_url(ArtForm.last)
  end

  test "should show art_form" do
    get art_form_url(@art_form)
    assert_response :success
  end

  test "should get edit" do
    get edit_art_form_url(@art_form)
    assert_response :success
  end

  test "should update art_form" do
    patch art_form_url(@art_form), params: { art_form: { active: @art_form.active, name: @art_form.name } }
    assert_redirected_to art_form_url(@art_form)
  end

  test "should destroy art_form" do
    assert_difference('ArtForm.count', -1) do
      delete art_form_url(@art_form)
    end

    assert_redirected_to art_forms_url
  end
end
