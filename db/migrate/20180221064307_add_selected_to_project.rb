class AddSelectedToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :selected, :boolean, :default => false
  end
end
