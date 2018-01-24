class Address < ApplicationRecord
  belongs_to :person
  # validates_presence_of  :street, :external_number, :colony, :zip 
end
