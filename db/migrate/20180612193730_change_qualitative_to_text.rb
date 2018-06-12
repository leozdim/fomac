class ChangeQualitativeToText < ActiveRecord::Migration[5.1]
  def change
    change_column :reports, :cuantitative, :text
    change_column :reports, :qualitative, :text
    change_column :reports, :activity, :text
  end
end
