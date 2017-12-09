require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = people(:one)
  end

  test "should get index" do
    get people_url
    assert_response :success
  end

  test "should get new" do
    get new_person_url
    assert_response :success
  end

  test "should create person" do
    assert_difference('Person.count') do
      post people_url, params: { person: { address_id: @person.address_id, birthdate: @person.birthdate, birthdate: @person.birthdate, birthplace: @person.birthplace, cellphone: @person.cellphone, city: @person.city, first_name: @person.first_name, home_phone_number: @person.home_phone_number, last_name: @person.last_name, level_study: @person.level_study, nationality: @person.nationality, second_last_name: @person.second_last_name, state: @person.state } }
    end

    assert_redirected_to person_url(Person.last)
  end

  test "should show person" do
    get person_url(@person)
    assert_response :success
  end

  test "should get edit" do
    get edit_person_url(@person)
    assert_response :success
  end

  test "should update person" do
    patch person_url(@person), params: { person: { address_id: @person.address_id, birthdate: @person.birthdate, birthdate: @person.birthdate, birthplace: @person.birthplace, cellphone: @person.cellphone, city: @person.city, first_name: @person.first_name, home_phone_number: @person.home_phone_number, last_name: @person.last_name, level_study: @person.level_study, nationality: @person.nationality, second_last_name: @person.second_last_name, state: @person.state } }
    assert_redirected_to person_url(@person)
  end

  test "should destroy person" do
    assert_difference('Person.count', -1) do
      delete person_url(@person)
    end

    assert_redirected_to people_url
  end
end
