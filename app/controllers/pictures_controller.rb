class PicturesController < ApplicationController

	before_action :find_picture, only: [:show, :edit, :update, :destroy, :upvote]

	respond_to :js, :json, :html

	def autocomplete
		render json: Picture.search(params[:query], autocomplete: true, limit: 10).map(&:title)
		# render json: Picture.search(params[:query], autocomplete: true, limit: 10).map(&:title,&:description)
	end

	def bubbleBarSearch
		redirect_to pictures_path(:srchterm => params[:srchterm])
	end

	def create
		@picture = current_user.pictures.build(picture_params)

		if @picture.save

			# now do keyword creation
			#
			keywords = keywordStringToKeywords(picture_params[:keywords])

			msg = ""
			keywords.each do |kw|
				keyword = Keyword.new do |x|
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
		# first delete all related keywords
		#
		keywords = Keyword.where(:picture_id => @picture.id)
		keywords.each do |kw|
			kw.destroy
		end

		@picture.destroy
		redirect_to root_path
	end

	def edit
		# get and dsiplay any existing keywords
		#
		keywords = Keyword.where(:picture_id => @picture.id)

		@keywordString = keywordArrayToKeywordString(keywords)
		# add double quotes to any keywords containing whitespace
		# before concatenating them onto the string
		#
		# keywords.each do |kw|
		# 	test = kw.word =~ /\s+/
		# 	if test.nil?
		# 		@keywordString += " #{kw.word} "
		# 	else
		# 		@keywordString += " \"#{kw.word}\" "
		# 	end
		# end
	end

	def index

		# initialize the pictures array
		#
		@pictures = Picture.first
		if params[:srchterm].present?

			# if the search button was hit, search pictures for the terms
			@pictures = []
			results = Picture.search(params[:srchterm], page: params[:page])
			results.each do |x|
				@pictures << x
			end

			# also search keywords for the search terms
			#
			keywords = Keyword.search(params[:srchterm], page: params[:page])

			# retrieve images based on keywords
			#
			keywords.each do |kw|
				pics = Picture.where(:id => kw.picture_id)
				pics.each do |pic|
					# only add to results if unique
					#
					if !@pictures.include? pic
						@pictures << pic
					end
				end
			end

		else
			@pictures = Picture.all.order("RANDOM()")
		end

	end

	def landing
		@pictures = Picture.all.order("RANDOM()")
		if params[:srchterm].present?
			redirect_to pictures_path(params)
		else
			@pictures = Picture.all.order("RANDOM()")
		end


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
		@keywordString = ""
	end

	def show
		@keywords = Keyword.where(:picture_id => @picture.id)
	end

	def update

		if @picture.update(picture_params)

			# get list of possibly changed keywords
			#
			editKeywords = keywordStringToKeywords(picture_params[:keywords])

			# make list of existing keywords
			#
			keywordArray = Keyword.where(:picture_id => @picture.id)
			keywords = keywordStringToKeywords(keywordArrayToKeywordString(keywordArray))

			# compare the two arrays for changes
			#
			deletedKeywords = keywords - editKeywords
			newKeywords = editKeywords - keywords

			# delete any removed keywords
			#
			deletedKeywords.each do |kw|
				toBeDeleted = Keyword.where(:picture_id => @picture.id, :word => kw)
				toBeDeleted.each do |x|
					x.destroy
				end
			end

			# add any new keywords
			#
			msg = ""
			newKeywords.each do |kw|
				keyword = Keyword.new do |x|
					x.picture_id = @picture.id
					x.word = kw
				end
				if !keyword.save
					msg = "keyword #{kw} add failure. "
				end
			end

			redirect_to @picture, notice: "Image was successfully updated " + msg
		else
			render "edit"
		end
	end

	def upvote
		@picture.upvote_by current_user
		redirect_to :back
	end

	# function that takes a string of space separated keywords
	# and returns an array of keywords
	#
	def keywordStringToKeywords(keywordString)

		# first split out any double quoted strings from the keyword list
		#
		quotes = keywordString.downcase.scan(/"([^"]*)"/).flatten

		# also remove any quoted strings from the keyword list, to
		# be added later
		#
		keywords = keywordString.gsub(/"([^"]*)"/, '')

		# process keyword array to replace commas or other punctuation with whitespace
		#
		keywords.downcase.gsub(/[^[:word:]\s]/, '')

		# split keyword string into individual keywords
		#
		singleKeywords = keywords.split(" ")

		# now push each of the multi-string keywords back onto
		# the master list of keywords
		#
		quotes.each do |q|
			if q != ""
				singleKeywords.push q
			end
		end

		return singleKeywords

	end

	# convert an array of keyword objects to a single string
	# with multiple-word keywords surrounded by double quotes
	#
	def keywordArrayToKeywordString(keywordArray)
		keywordString = ""

		keywordArray.each do |kw|
			test = kw.word =~ /\s+/
			if test.nil?
				keywordString += " #{kw.word} "
			else
				keywordString += " \"#{kw.word}\" "
			end
		end

		return keywordString
	end

private
	def picture_params
		params.require(:picture).permit(:title, :description, :image, :keywords)
	end

	def find_picture
		@picture = Picture.find(params[:id])
	end

end
