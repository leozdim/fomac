class ChangePhotosToText < ActiveRecord::Migration[5.1]
  def change
    change_column :report_docs, :photos, :text
  end
end
