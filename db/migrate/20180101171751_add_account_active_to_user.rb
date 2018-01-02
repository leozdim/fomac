class AddAccountActiveToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :account_active, :boolean
  end
end
