require 'test_helper'

class EvaluationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evaluation = evaluations(:one)
  end

  test "should get index" do
    get evaluations_url
    assert_response :success
  end

  test "should get new" do
    get new_evaluation_url
    assert_response :success
  end

  test "should create evaluation" do
    assert_difference('Evaluation.count') do
      post evaluations_url, params: { evaluation: { clarity_text: @evaluation.clarity_text, clarity_value: @evaluation.clarity_value, creativity_text: @evaluation.creativity_text, creativity_value: @evaluation.creativity_value, excellence_text: @evaluation.excellence_text, excellence_value: @evaluation.excellence_value, feasibility_text: @evaluation.feasibility_text, feasibility_value: @evaluation.feasibility_value, impact_text: @evaluation.impact_text, impact_value: @evaluation.impact_value, innovation_text: @evaluation.innovation_text, innovation_text: @evaluation.innovation_text, innovation_value: @evaluation.innovation_value, innovation_value: @evaluation.innovation_value, justification_text: @evaluation.justification_text, justification_value: @evaluation.justification_value, originality_text: @evaluation.originality_text, originality_value: @evaluation.originality_value, project_assignment_id: @evaluation.project_assignment_id, schema_text: @evaluation.schema_text, schema_value: @evaluation.schema_value, timeframe_text: @evaluation.timeframe_text, timeframe_value: @evaluation.timeframe_value } }
    end

    assert_redirected_to evaluation_url(Evaluation.last)
  end

  test "should show evaluation" do
    get evaluation_url(@evaluation)
    assert_response :success
  end

  test "should get edit" do
    get edit_evaluation_url(@evaluation)
    assert_response :success
  end

  test "should update evaluation" do
    patch evaluation_url(@evaluation), params: { evaluation: { clarity_text: @evaluation.clarity_text, clarity_value: @evaluation.clarity_value, creativity_text: @evaluation.creativity_text, creativity_value: @evaluation.creativity_value, excellence_text: @evaluation.excellence_text, excellence_value: @evaluation.excellence_value, feasibility_text: @evaluation.feasibility_text, feasibility_value: @evaluation.feasibility_value, impact_text: @evaluation.impact_text, impact_value: @evaluation.impact_value, innovation_text: @evaluation.innovation_text, innovation_text: @evaluation.innovation_text, innovation_value: @evaluation.innovation_value, innovation_value: @evaluation.innovation_value, justification_text: @evaluation.justification_text, justification_value: @evaluation.justification_value, originality_text: @evaluation.originality_text, originality_value: @evaluation.originality_value, project_assignment_id: @evaluation.project_assignment_id, schema_text: @evaluation.schema_text, schema_value: @evaluation.schema_value, timeframe_text: @evaluation.timeframe_text, timeframe_value: @evaluation.timeframe_value } }
    assert_redirected_to evaluation_url(@evaluation)
  end

  test "should destroy evaluation" do
    assert_difference('Evaluation.count', -1) do
      delete evaluation_url(@evaluation)
    end

    assert_redirected_to evaluations_url
  end
end
