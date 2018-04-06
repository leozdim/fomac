class Report < ApplicationRecord
  belongs_to :project
  has_one :report_doc

  accepts_nested_attributes_for :report_doc
  validates_presence_of :year, :period, :number, :cuantitative, :qualitative, :activity ,:programed_date, :real, :place, :number_people, :money_received
  validates_presence_of :report_doc


  validates_associated :report_doc

end
