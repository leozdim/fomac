class CreateJoinTableProjectArtForm < ActiveRecord::Migration[5.1]
  def change
    create_join_table :projects, :art_forms do |t|
       t.index [:project_id, :art_form_id]
       #t.index [:art_form_id, :project_id]
    end
  end
end
