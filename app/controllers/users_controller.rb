class UsersController < ApplicationController

	before_action :find_user, only: [:show,:update]
	before_action :find_profile, only: [:show,:update]

	def index
		@users = User.all.order("created_at DESC")
	end

	def show
		@pics = @user.pictures()
		@freePix = @pics[0..4]
		@userPix = @pics.drop(5)
	end

	def update
		puts 20 * "="
		puts " updating user "
		puts 20 * "="
		
		if @user.update(user_params)
			redirect_to @user, notice: "Profile successfully updated"
		else
			render "edit"
		end
	end

private
	def picture_params
		# params.require(:picture).permit(:title, :description, :image, :profile_id)
		params.require(:picture).permit(:title, :description, :image)
	end

	def user_params
		params.require(:user).permit(:email, :username, profile_attributes: [:brandname, :avatar, :description, :heroImage])
	end

	def find_user
		@user = User.find(params[:id])
	end

	def find_profile
		@profile = Profile.find(@user.profile_id)
	end
end
