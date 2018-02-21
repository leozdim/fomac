class Report < ApplicationRecord
  belongs_to :project
  has_one :report_doc

  accepts_nested_attributes_for :report_doc

end
