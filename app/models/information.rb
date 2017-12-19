class Information < ApplicationRecord
  belongs_to :project
  mount_uploader :activities, DocumentsUploader
  mount_uploader :spending, DocumentsUploader
  mount_uploader :funding, DocumentsUploader
end
