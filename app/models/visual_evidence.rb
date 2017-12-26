class VisualEvidence < ApplicationRecord
  belongs_to :project
  mount_uploaders :catalog, DocumentsUploader
  serialize :catalog, JSON
  mount_uploaders :image, DocumentsUploader
  serialize :image, JSON
  mount_uploaders :note, DocumentsUploader
  serialize :note, JSON
  mount_uploaders :document, DocumentsUploader
  serialize :document, JSON
  validates_presence_of :image, :catalog, :note, :document

  def images
    image.map{|x| x.url}.join ','
  end

  def catalogs
    catalog.map{|x| x.url}.join ','
  end

  def notes
    note.map{|x| x.url}.join ','
  end

  def documents
    document.map{|x| x.url}.join ','
  end

end
