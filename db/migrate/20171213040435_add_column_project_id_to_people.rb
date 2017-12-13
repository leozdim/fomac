class AddColumnProjectIdToPeople < ActiveRecord::Migration[5.1]
  def change
    add_reference :people, :project, foreign_key: true
  end
end
