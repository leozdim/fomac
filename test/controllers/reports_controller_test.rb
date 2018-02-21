require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report = reports(:one)
  end

  test "should get index" do
    get reports_url
    assert_response :success
  end

  test "should get new" do
    get new_report_url
    assert_response :success
  end

  test "should create report" do
    assert_difference('Report.count') do
      post reports_url, params: { report: { activity: @report.activity, cuantitative: @report.cuantitative, money_received: @report.money_received, number: @report.number, number_people: @report.number_people, period: @report.period, place: @report.place, programed_date: @report.programed_date, project_id: @report.project_id, qualitative: @report.qualitative, real: @report.real, year: @report.year } }
    end

    assert_redirected_to report_url(Report.last)
  end

  test "should show report" do
    get report_url(@report)
    assert_response :success
  end

  test "should get edit" do
    get edit_report_url(@report)
    assert_response :success
  end

  test "should update report" do
    patch report_url(@report), params: { report: { activity: @report.activity, cuantitative: @report.cuantitative, money_received: @report.money_received, number: @report.number, number_people: @report.number_people, period: @report.period, place: @report.place, programed_date: @report.programed_date, project_id: @report.project_id, qualitative: @report.qualitative, real: @report.real, year: @report.year } }
    assert_redirected_to report_url(@report)
  end

  test "should destroy report" do
    assert_difference('Report.count', -1) do
      delete report_url(@report)
    end

    assert_redirected_to reports_url
  end
end
