class Relationship < ActiveRecord::Base
	attr_accessible :accessed_id, :accepted
	
	belongs_to :accessor, :class_name => "User"
	belongs_to :accessed, :class_name => "User"
	
	validates :accessor_id, :presence => true
	validates :accessed_id, :presence => true
end
