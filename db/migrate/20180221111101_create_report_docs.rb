class CreateReportDocs < ActiveRecord::Migration[5.1]
  def change
    create_table :report_docs do |t|
      t.references :report, foreign_key: true
      t.string :photos
      t.string :video
      t.string :payslips
      t.string :press
      t.string :publicity
      t.timestamps
    end
  end
end
