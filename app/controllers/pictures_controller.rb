class PicturesController < ApplicationController

	before_action :find_picture, only: [:show, :edit, :update, :destroy]

	def create
		@picture = current_user.pictures.build(picture_params)

		if @picture.save

			# now do keyword creation

			keywordString = picture_params[:keywords]

			# process keyword array to replace commas or other punctuation with whitespace
			keywordString.downcase.gsub(/[^[:word:]\s]/, '')

			# split keyword string into keywords
			keywords = keywordString.split(" ")

			puts "=" * 20
			puts keywords
			puts "=" * 20

			msg = ""
			keywords.each do |kw|
				keyword = Keyword.new do |x|
					puts "               #{x}"
					x.picture_id = @picture.id
					x.word = kw
				end
				if !keyword.save
					msg = "keyword #{kw} add failure. "
				end
			end

			redirect_to @picture, notice: "Successfully Created new Image" + msg
		else
			render "new"
		end
	end

	def destroy
		@picture.destroy
		redirect_to root_path
	end

	def edit
		# compare existing keywords to any new keywords, change accordingly
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
		@artMonthStuff ||= []
		if @artMonth.present?
			fivePix = Picture.where(:user_id => @artMonth.id).limit(5) 
			if (fivePix.length > 0)
				@featPix = fivePix[0]
				fivePix.each_with_index do | pix, i | 
					if i > 0
						@artMonthStuff << pix 
					end
				end
			end
		end
	end

	def new
		@picture = current_user.pictures.build
	end

	def show
		@keywords = Keyword.where(:picture_id => @picture.id)
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
