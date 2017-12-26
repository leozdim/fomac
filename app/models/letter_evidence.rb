class LetterEvidence < ApplicationRecord
  belongs_to :project

  mount_uploader :work, DocumentsUploader
  mount_uploaders :cover, DocumentsUploader
  serialize :cover, JSON
  validates_presence_of  :web , :work, :cover

  def covers
      cover.map{|x| x.file.filename}.join ','
  end
end
