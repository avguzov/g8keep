# == Schema Information
# Schema version: 20101204032019
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'
class User < ActiveRecord::Base
	
	attr_accessor :password
	attr_accessible :username, :first_name, :last_name, :home_phone, :work_phone, :cell_phone, :personal_email, :work_email, :password, :password_confirmation
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	phone_regex = /^(1\s*[-\/\.]?)?(\((\d{3})\)|(\d{3}))\s*[-\/\.]?\s*(\d{3})\s*[-\/\.]?\s*(\d{4})\s*(([xX]|[eE][xX][tT])\.?\s*(\d+))*$/
	
		
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
							   :allow_nil => true,
							   :allow_blank => true
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
						 
	has_many :relationships, :foreign_key => "accessor_id",
							 :dependent => :destroy
	has_many :accessing, :through => :relationships, 
						 :source => :accessed

	has_many :reverse_relationships, :foreign_key => "accessed_id",
									 :class_name => "Relationship",
									 :dependent => :destroy
	has_many :accessors, :through => :reverse_relationships,
									 :source => :accessor
						 
	before_save :encrypt_password
	
	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end
	
	def self.authenticate(username, submitted_password)
		user = find_by_username(username)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end
	
	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end
	
	def accessing?(accessed)
		relationships.where("accessed_id = ? AND accessor_id = ? AND accepted = ?", accessed.id, self.id, true).first || relationships.where("accessed_id = ? AND accessor_id = ? AND accepted = ?", accessed.id, self.id, true).first || (accessed.id == self.id)
	end
	
	def requesting?(accessed)
		relationships.where("accessed_id = ? AND accessor_id = ? AND accepted = ?", accessed.id, self.id, false).first
	end
	
	def access!(accessed)
		relationships.create!(:accessed_id => accessed.id)
	end
	
	def unaccess!(accessed)
		relationships.find_by_accessed_id(accessed).destroy
	end
	
	def self.search(search)
		if search
			where("username LIKE ? OR first_name LIKE ? OR last_name LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
		else
			find(:all)
	end
end
	
	private
	
		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end
		
		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end
		
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end

end
