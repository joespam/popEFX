# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$('#signupGal').imagesLoaded ->
		$gallery = $('#signupGal')
		$gallery.masonry
			isAnimated: true
			isFitWidth: true
			itemSelector: '.picTile'
			stamp: '.signupForm'
			

