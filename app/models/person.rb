class Person < ApplicationRecord
  belongs_to :address
  has_one :user
end
