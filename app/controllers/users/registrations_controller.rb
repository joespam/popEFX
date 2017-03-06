class Users::RegistrationsController < Devise::RegistrationsController

   before_action :configure_permitted_parameters, if: :devise_controller?
   after_action :set_profile, only: [:create]

	def configure_permitted_parameters
	   devise_parameter_sanitizer.permit(:sign_up, keys: 
	   	[:email, :username, :password, :password_confirmation, :remember_me, :profile_id,
				{pictures: []}, profile_attributes: [:brandname, :description, :avatar]
			]
		)
	   devise_parameter_sanitizer.permit(:account_update, keys: 
	   	[:email, :username, :password, :password_confirmation, :remember_me, :profile_id,
				{pictures: []}, profile_attributes: [:brandname, :description, :avatar]
			]
		)
	end

	def create
		super

		if params[:user][:pictures].present?

				@user.pictures.build(image: params[:user][:pictures]) 
				@user.pictures.last.save
		end
      # if params[:user][:pictures].present?
      	# array input not currently working
      	#
   #    	puts ""
   #    	puts "There are #{params[:pictures].length} Pictures uploaded!"
   #    	puts ""
			# params[:user][:pictures].each { |image|
			# 	puts "Checking for image #{'-' * 20}"
			# 	@user.pictures.build(image: image) if image.present?
			# }

      # end

		if params[:user][:picture1].present?
			@user.pictures.build(image: params[:user][:picture1]) 
			@user.pictures.last.save
		end

		if params[:user][:picture2].present?
			@user.pictures.build(image: params[:user][:picture2]) 
			@user.pictures.last.save
		end

		if params[:user][:picture3].present?
			@user.pictures.build(image: params[:user][:picture3]) 
			@user.pictures.last.save
		end

		if params[:user][:picture4].present?
			@user.pictures.build(image: params[:user][:picture4]) 
			@user.pictures.last.save
		end

		if params[:user][:picture5].present?
			@user.pictures.build(image: params[:user][:picture5]) 
			@user.pictures.last.save
		end

	end

	def set_profile
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
		@displayPixH = [];
		@displayPixV = [];

		if ( totalPix%2 == 0 ) 
			@displayPixH = @displayPix[0..(totalPix/2)-1]
			@displayPixV = @displayPix[totalPix/2..totalPix-1]
		else
			@displayPixH = @displayPix[0..(totalPix-1)/2]
			@displayPixV = @displayPix[(totalPix-1)/2 + 1..totalPix-1]
		end
		super

	end

	def update
		super
	end
end
