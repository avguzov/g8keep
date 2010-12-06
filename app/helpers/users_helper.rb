module UsersHelper
	def gravatar_for(user, options = { :size => 50 })
		gravatar_image_tag(user.personal_email.downcase, :alt => "#{user.first_name} #{user.last_name}",
												:class => 'gravatar',
												:gravatar => options)
	end
end
