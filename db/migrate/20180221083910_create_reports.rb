class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.references :project, foreign_key: true
      t.string :year
      t.string :period
      t.string :number
      t.string :cuantitative
      t.string :qualitative
      t.string :activity
      t.date :programed_date
      t.date :real
      t.string :place
      t.string :number_people
      t.string :money_received

      t.timestamps
    end
  end
end
