class UsersController < ApplicationController

	before_action :find_user, only: [:follow,:show,:update]
	before_action :find_profile, only: [:show,:update]

	def destroy
		# find all related follow records
		super
	end

	def follow

		profile = Profile.find(current_user.profile_id)
		profile2 = Profile.find(@user.profile_id)
		if params[:follow] == 'on'
			# current_user wants to follow user
			#
			chase = Following.new();
			chase.follower = current_user.id
			chase.following = @user.id
			chase.save

			puts '-' * 30
			puts profile.brandname + ' now follows ' + profile2.brandname
			puts '-' * 30
		else
			# current user wants to unfollow user
			#

			follows = Following.where("follower = #{current_user.id} AND following = #{@user.id}")
			if follows.length !=1
				puts "error attempting to unfollow, #{follows.length} records found, should be 1"
			else
				follows[0].destroy
			end 

			puts '*' * 30
			puts profile.brandname + ' stopped following ' + profile2.brandname
			puts '*' * 30
		end

		# respond_to do |format|
		# 	# all updating is takencare of in javascript, no action necessary here
		# 	# a 406 error is returned by the server, but there's no consequence to the user
		# end

	end

	def patch

	end

	def index
		@users = User.all.order("created_at DESC")
	end

	def show
		@pics = @user.pictures()
		@freePix = @pics[0..4]
		@userPix = @pics.drop(5)
		@following = is_following
		if current_user == @user
			@following_list = Following.where("follower = #{current_user.id}")
		end

	end

	def update
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

	# return whether current_user is following @user
	#
	def is_following
		follows = 0
		following = false
		if current_user != @user
			follows = Following.where("follower = #{current_user.id} AND following = #{@user.id}")
		end
		if follows.length != 0 
			following = true
		end

		return following
	end

end
