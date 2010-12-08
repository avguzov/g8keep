# Requiring 'digest' allows the method for SHA2 encryption to be called on the password before it's stored
require 'digest'

#User records should require:
# * first_name
# * last_name
# * personal_email
# * username
# * password
# All other fields are optional.
# Each instance of the User class represents one user of the website
# with their information stored in the User table.
class User < ActiveRecord::Base
	
	# specifies that password attribute is never stored directly in the table, because it's first encrypted
	attr_accessor :password
	
	# specifies which User attributes can be accessed from a given user
	attr_accessible :username, :first_name, :last_name, :home_phone, :work_phone, :cell_phone, :personal_email, :work_email, :password, :password_confirmation
	
	# Regular expressions for ensuring that visitors to the website format their email addresses
	# and phone numbers in a proper format
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	phone_regex = /^(1\s*[-\/\.]?)?(\((\d{3})\)|(\d{3}))\s*[-\/\.]?\s*(\d{3})\s*[-\/\.]?\s*(\d{4})\s*(([xX]|[eE][xX][tT])\.?\s*(\d+))*$/
	
	# Series of validations for the different attributes to make sure they fit certain guidelines	
	validates :first_name, :presence => true,
					 :length => { :maximum => 40 }
	validates :username, :presence => true,
					 :length => { :within => 6..40 },
					 :uniqueness => true
	validates :last_name, :presence => true,
					 :length => {:maximum => 40 }
	validates :home_phone, 	   :format => { :with => phone_regex },
						       :allow_nil => true,
							   :allow_blank => true
    validates :work_phone, 	   :format => { :with => phone_regex },
							   :allow_nil => true,
							   :allow_blank => true
	validates :cell_phone, 	   :format => { :with => phone_regex },
							   :presence => true
	validates :personal_email, :format => { :with => email_regex },
							   :uniqueness => { :case_sensitive => false },
							   :presence => true
	validates :work_email, :format => { :with => email_regex },
						   :uniqueness => { :case_sensitive => false },
						   :allow_nil => true,
						   :allow_blank => true
	validates :password, :presence	=> true,
						 :confirmation => true,
						 :length => { :within => 6..40 }
	
	# The following lines explain the relationship between each instance of user and other 
	# elements of the database
	has_many :relationships, :foreign_key => "accessor_id",
							 :dependent => :destroy
	has_many :accessing, :through => :relationships, 
						 :source => :accessed

	has_many :reverse_relationships, :foreign_key => "accessed_id",
									 :class_name => "Relationship",
									 :dependent => :destroy
	has_many :accessors, :through => :reverse_relationships,
									 :source => :accessor
	
	# Executes the encrypt_password method before a new User is saved
	before_save :encrypt_password
	
	# Checks to see whether the encrypted version of the submitted password matches the stored
	# encrypted password.
	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end
	
	# Checks to see whether a user exists in the database with the submitted username and password
	def self.authenticate(username, submitted_password)
		user = find_by_username(username)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end
	
	# Checks to see whether a user exists in the database with the submitted user id and salt
	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end
	
	# Checks to see whether a user has access to the contact information of the user in the parameter
	def accessing?(accessed)
		relationships.where("accessed_id = ? AND accessor_id = ? AND accepted = ?", accessed.id, self.id, true).first || relationships.where("accessed_id = ? AND accessor_id = ? AND accepted = ?", accessed.id, self.id, true).first || (accessed.id == self.id)
	end
	
	# Checks to see whether a user has requested access to the contact information of the user in the parameter
	def requesting?(accessed)
		relationships.where("accessed_id = ? AND accessor_id = ? AND accepted = ?", accessed.id, self.id, false).first
	end
	
	# Creates an instance of the Relationship model, linking the current user as the accessor user
	# to the user in the paramater as the accessed user
	def access!(accessed)
		relationships.create!(:accessed_id => accessed.id)
	end
	
	# Destroys an instance of the Relationship model, unlinking the current user as the accessor user
	# from the user in the paramater as the accessed user
	def unaccess!(accessed)
		relationships.find_by_accessed_id(accessed).destroy
	end
	
	# Checks to see whether the User table has an users whose name attributes are similar to the
	# contents of the parameter search
	
	def self.search(search)
		if search
			where("username LIKE ? OR first_name LIKE ? OR last_name LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
		else
			find(:all)
	end
end
	
	private
	
		# Encrypts the password, encrypting the password with the salt
		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end
		
		# Encrypts the string parameter, using the salt and the parameter string
		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end
		
		# Makes a salt, encrypting a combination of the current time and the input password
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		# Encrypts a string parameter using SHA2 encryption
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end

end
