class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :second_last_name
      t.date :birthdate
      t.string :home_phone_number
      t.string :cellphone
      t.string :birthplace
      t.string :state
      t.string :city
      t.string :nationality
      t.string :level_study
      t.string :email

      t.timestamps
    end
  end
end
