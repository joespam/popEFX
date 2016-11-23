class Users::RegistrationsController < Devise::RegistrationsController

   before_action :configure_permitted_parameters, if: :devise_controller?

	def configure_permitted_parameters
	   devise_parameter_sanitizer.permit(:sign_up, keys: 
	   	[:email, :username, :password, :password_confirmation, :remember_me, 
				profile_attributes: [:brandname, :description]
			]
		)

	end
end
