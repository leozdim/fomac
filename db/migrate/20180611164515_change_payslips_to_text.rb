class ChangePayslipsToText < ActiveRecord::Migration[5.1]
  def change
    change_column :report_docs, :payslips, :text
    change_column :report_docs, :video, :text
    change_column :report_docs, :press, :text
    change_column :report_docs, :publicity, :text
  end
end
