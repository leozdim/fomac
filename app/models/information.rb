class Information < ApplicationRecord
  belongs_to :project
  mount_uploader :activities, DocumentsUploader
  mount_uploader :spending, DocumentsUploader
  mount_uploader :funding, DocumentsUploader
  validates_presence_of :name,:description,:antecedent,:justification,:general_objective,
       :specific_objective,:goals,:beneficiary,:context,:activities , :bibliography #,:spending,:funding
end
