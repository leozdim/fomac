class PersonDocument < ApplicationRecord
  belongs_to :person
  has_one :project , through: :person
  mount_uploader :request_letter, DocumentsUploader
  mount_uploader :birth, DocumentsUploader
  mount_uploader :address, DocumentsUploader
  mount_uploader :identification, DocumentsUploader
  mount_uploader :curp, DocumentsUploader
  mount_uploader :resume, DocumentsUploader
  mount_uploader :kardex, DocumentsUploader
  mount_uploader :agreement_letter, DocumentsUploader
  mount_uploader :assign_letter, DocumentsUploader

  # validates_presence_of :request_letter,:birth,:address,:identification,:curp,:resume
end
