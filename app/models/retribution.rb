class Retribution < ApplicationRecord
  belongs_to :project
  belongs_to :modality
  belongs_to :art_activity
end
