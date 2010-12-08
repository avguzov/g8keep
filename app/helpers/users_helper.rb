# Defines helper functions to be used in the Users view

module UsersHelper
	# Takes in a user object, and then passes it, along with some default options,
	# to the gravatar_image_tag helper
	def gravatar_for(user, options = { :size => 50 })
		gravatar_image_tag(user.personal_email.downcase, :alt => "#{user.first_name} #{user.last_name}",
												:class => 'gravatar',
												:gravatar => options)
	end
end
