class LetterEvidence < ApplicationRecord
  belongs_to :project

  mount_uploader :work, DocumentsUploader
  mount_uploaders :cover, DocumentsUploader
  serialize :cover, JSON

  def covers
    cover.map{|x| x.url}.join ','
  end
end
