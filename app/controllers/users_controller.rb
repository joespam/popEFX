class UsersController < ApplicationController

	before_action :find_user, only: [:show]
	before_action :find_profile, only: [:show]

	def index
		@users = User.all.order("created_at DESC")
	end

	def show
		@pics = @user.pictures()
		@freePix = @pics[0..4]
		@userPix = @pics.drop(4)
	end

	def update
		if @picture.update(picture_params)
			redirect_to @picture, notice: "Image was successfully updated"
		else
			render "edit"
		end
	end

private
	def picture_params
		params.require(:picture).permit(:title, :description, :image, :profile_id)
	end

	def find_user
		@user = User.find(params[:id])
	end

	def find_profile
		@profile = Profile.find(@user.profile_id)
	end
end
