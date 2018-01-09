class AddModelToRevisions < ActiveRecord::Migration[5.1]
  def change
    add_column :revisions, :model, :string
  end
end
