class Category < ApplicationRecord
  def self.options_array
    all.order(:name).map{|c| [c.name,c.id,{'data-single'=> c.single}] }
  end
end
