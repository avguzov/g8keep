#The Relationship model links users through the following required variables:
# * accessor_id
# * accessed_id
# * accepted
# 
# An instance of this class is created when the logged-in user requests
# access to another user's contact information.  At this point, the 
# instance is created, but the accepted attribute is false.  If the 
# requested user grants contact information access to the user who
# put in the request, the accepted attribute becomes true, and both
# users can see one another's contact information.  If the requested
# user denies access, the Relationship instance is destroyed.

class Relationship < ActiveRecord::Base

	# Specifies which attributes in a Relationship instance can be
	# accessed.
	attr_accessible :accessed_id, :accepted
	
	# Specifies the relationship between instances of the Relationsip
	# class and other elements in the database
	belongs_to :accessor, :class_name => "User"
	belongs_to :accessed, :class_name => "User"
	
	# Validates attributes of the Relationship class
	validates :accessor_id, :presence => true
	validates :accessed_id, :presence => true
end
