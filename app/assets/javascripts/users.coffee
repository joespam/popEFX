# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$('#signupGal').imagesLoaded ->
		$('#signupGal').masonry
			itemSelector: '.picTile'
			stamp: '.signupForm'
			isAnimated: true
			isFitWidth: true