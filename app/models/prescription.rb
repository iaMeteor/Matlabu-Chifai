class Prescription < ActiveRecord::Base
  has_and_belongs_to_many :medication
  belongs_to :conditions
end
