class PicturesController < ApplicationController

	before_action :find_picture, only: [:show,:edit,:update, :destroy]

	def create
		@picture = Picture.new(picture_params)

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
		@pictures = Picture.all.order("created_at DESC")
	end

	def new
		@picture = Picture.new
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
		params.require(:picture).permit(:title, :description)
	end

	def find_picture
		@picture = Picture.find(params[:id])
	end

end
