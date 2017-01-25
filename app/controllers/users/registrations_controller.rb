class Users::RegistrationsController < Devise::RegistrationsController

   before_action :configure_permitted_parameters, if: :devise_controller?
   after_action :set_profile

	def configure_permitted_parameters
	   devise_parameter_sanitizer.permit(:sign_up, keys: 
	   	[:email, :username, :password, :password_confirmation, :remember_me, 
				:profile_id, profile_attributes: [:brandname, :description, :avatar]
			]
		)
		u = User.count
	end

	def set_profile
		p params
		if User.count > 0
			u = User.last
			p = Profile.last
			u.profile_id = p.id
			# all users default to level 1
			p.level = 1
			p.save
			u.save
		end
	end

	def new
		# take the lesser of total pictures and 100 and put
		# half that number of pictures in each picture display
		# array without duplicating pictures.
		#
		totalPix = Picture.count > 100 ? 100 : Picture.count

		@displayPix = Picture.limit(totalPix).order("RANDOM()")
		puts "================ #{totalPix} ===================================="
		super
	end
end
