json.extract! report, :id, :project_id, :year, :period, :number, :cuantitative, :qualitative, :activity, :programed_date, :real, :place, :number_people, :money_received, :created_at, :updated_at
json.url report_url(report, format: :json)
