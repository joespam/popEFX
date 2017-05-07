class ProfilesController < ApplicationController

	before_action :find_user, only: [:edit,:update,:upvote]

	def edit
		@profile = @user.profile
	end

	def update

		user = User.find_by_id params[:user_id]
		profile = user.profile

		if user and profile and profile.update_attributes profile_params
			flash[:notice] = "Profile updated successfully"
			redirect_to user_path user
		else
			flash[:alert] = "Updating failed."
			redirect_to edit_user_profile_path user
		end
	end	

	def upvote
		@user.upvote_by current_user
		redirect_to :back
	end

	private
	def profile_params
		params.require(:profile).permit(:brandname, :avatar, :description, :level)
	end

	def find_user
		@user = User.find(params[:user_id])
	end

end
