class FilmEvidence < ApplicationRecord
  belongs_to :project

  mount_uploader :synopsis, DocumentsUploader
  mount_uploader :script, DocumentsUploader
  mount_uploader :plan, DocumentsUploader
  mount_uploader :letter, DocumentsUploader
  validates_presence_of :video, :web , :demo, :script, :plan, :synopsis, :letter
  ART_FORM_ID=5

end
