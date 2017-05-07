require "RMagick"
require File.dirname(__FILE__) + '/../config/environment.rb'

module Watermark

	include Magick

	# watermark an array of picture objects
	#
	def self.watermarkArray(picArray)
		watermarked = []
		picArray.each do |pic|
			watermarked << textmarkImage(pic.image.url)
		end

		# explicit return to avoid confusion
		#
		return watermarked
	end

	# Watermarking image with text using ImageMagick 'composite', 'watermark' and 'dissolve'
	#    picture is assumed to be a valid path to an image
	#
	def self.textmarkImage(pictur)

		# currently this does not work for unknown reasons. The following 2
		# existing hardcoded picture paths fail when Image.read is called below.
		# This issue must be solved to have server level watermarking,  
		# then the proper findable image path must be passed in and the
		# function parameter restored to the variable 'picture'

		# legitimate pic in database - verify its presence before testing
		#
		picture = "/images/000/000/002/original/0mUW0Je.jpg"
		# online photo 
		#
		picture = "https://i.redd.it/y68f06slsouy.jpg"

		img = ImageList.new(picture)

		
		# Read the image in the memory with RMagick
		# img = Magick::Image.read(picture).first

		# Create a new image in memory with transparent canvas
		# size of this 'mark' image is same as original image which we want to watermark
		mark = Magick::Image.new(img.rows, img.columns) {self.background_color = "none"}
		draw = Magick::Draw.new

		# draw is used to add elements to an image like text
		draw.annotate(mark, 0, 0, 0, 0, "creative commons") do
		  # place the text in the centre of the canvas
		  draw.gravity = Magick::CenterGravity
		  # set text height in points where 1 point is 1/72 inches
		  draw.pointsize = 100
		  draw.font_family = "Times" # set font
		  draw.fill = "black" # set text color
		  draw.stroke = "none" # remove stroke
		end

		# rotate this mark by 45 degrees anticlockwise (optional)
		# if we do not specify 'background_color' on 'mark' then on rotation the background color will be black.
		# we want it to be transparent.
		mark = mark.rotate(-45)

		# using composite
		# place the watermark in the center of the image
		# default 'compose over' overlays the watermark on the background image
		# SoftLightCompositeOp darkens or lightens the colors, dependent on the source color value.
		# If the source color is lighter than 0.5, the destination is lightened.
		# If the source color is darker than 0.5, the destination is darkened, as if it were burned in.
		# The degree of darkening or lightening is proportional to the difference between the source color and 0.5.
		# If it is equal to 0.5, the destination is unchanged.
		# Painting with pure black or white produces a distinctly darker or lighter area, but does not result in pure black or white.
		img1 = img.composite(mark, Magick::CenterGravity, Magick::SoftLightCompositeOp)

		# save the watermarked image
		img1.write(picture)

		# using watermark
		# place the watermark in the center of the image with gravity
		# watermark the image with 20% brightness and 50% saturation
		img2 = img.watermark(mark, 0.2, 0.5, Magick::CenterGravity)
		# save the watermarked image
		img2.write(picture)

		# using dissolve
		# add watermark with 25% opacity for watermark, 50% opacity for image and position is center
		img3 = img.dissolve(mark, 0.25, 0.5, Magick::CenterGravity)
		# save the watermarked image
		img3.write(picture)
	end

	def self.imagemarkImage(pictur)
		# Read the image in the memory with RMagick
		img = Magick::Image.read(picture).first

		# the original image was in jpg format
		# need to make the white background color transparent
		# also changed the format to png since JPG does not support transparency.
		# run the command below to create an image with transparent background using ImageMagick
		# convert cc.png -transparent white -fuzz 2% watermark.png

		mark = Magick::Image.read("/home/aditya/Pictures/watermark.png").first

		# set the canvas to transparent
		# if we do not specify 'background_color' on 'mark' then on rotation the background color will be black.
		# we want it to be transparent.
		mark.background_color = "Transparent"

		# resize the watermark to 60% of the image we want to watermark

		watermark = mark.resize_to_fit(img.rows * 0.6, img.columns * 0.6)

		# rotate this mark by 45 degrees anticlockwise (optional)
		watermark.rotate!(-45)

		# using composite
		# place the watermark in the center of the image
		# default 'compose over' overlays the watermark on the background image
		# SoftLightCompositeOp darkens or lightens the colors, dependent on the source color value.
		# If the source color is lighter than 0.5, the destination is lightened.
		# If the source color is darker than 0.5, the destination is darkened, as if it were burned in.
		# The degree of darkening or lightening is proportional to the difference between the source color and 0.5.
		# If it is equal to 0.5, the destination is unchanged.
		# Painting with pure black or white produces a distinctly darker or lighter area, but does not result in pure black or white.
		img1 = img.composite(watermark, Magick::CenterGravity, Magick::SoftLightCompositeOp)
		# save the watermarked image
		img1.write(picture)

		# using watermark
		# place the watermark in the center of the image with gravity
		# watermark the image with 20% brightness and 30% saturation
		img2 = img.watermark(watermark, 0.2, 0.3, Magick::CenterGravity)
		# save the watermarked image
		img2.write(picture)

		# using dissolve
		# add watermark with 40% opacity for watermark, 100% opacity for image and position is center
		img3 = img.dissolve(watermark, 0.4, 1, Magick::CenterGravity)
		# save the watermarked image
		img3.write(picture)
	end
end