class PicturesController < ApplicationController

	before_action :find_picture, only: [:show,:edit,:update, :destroy]

	def create
		@picture = current_user.pictures.build(picture_params)

		keywords = picture_params

		if @picture.save
			redirect_to @picture, notice: "Successfully Created new Image"
		else
			render "new"
		end
	end

	def destroy
		@picture.destroy
		redirect_to root_path
	end

	def edit
	end

	def index
		@pictures = Picture.all.order("RANDOM()")
	end

	def landing
		@pictures = Picture.all.order("RANDOM()")
		@artMonth = User.first

		# information for featured artist
		# currently we need a system for designating that artist
		# right now its just the first user
		#
		if @artMonth.present?
			fivePix = Picture.where(:user_id => @artMonth.id).limit(5) 
			if (fivePix.length > 0)
				@featPix = fivePix[0]
				@artMonthStuff = [fivePix[1], fivePix[2], fivePix[3], fivePix[4]]
			end
		end
	end

	def new
		@picture = current_user.pictures.build
	end

	def show
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
		params.require(:picture).permit(:title, :description, :image, :keywords)
	end

	def find_picture
		@picture = Picture.find(params[:id])
	end

end
