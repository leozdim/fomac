class Retribution < ApplicationRecord
  belongs_to :project
  belongs_to :modality
  belongs_to :art_activity
  validates_presence_of  :modality, :art_activity, :description
end
