// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require masonry/jquery.masonry
//= require_tree .

// 
//  featureFit
//		given element id <name>, an img <img>, and the number of images
//		per row <perRow>, set the backgraound css properties of name to img 
//
function featureFit(name,img, perRow) {

	// get width and height of featured div
	var featWidth = $('#featured').css("width");
	var featHeight = $('#featured').css("height");
	featWidth = parseInt(featWidth);
	featHeight = parseInt(featHeight);

	var padding = $('#' + name).css("padding");
	padding = parseInt(padding);

	// smallest featured tile has width = 1/4 of featured's and height 1/4
	var tileWidth = parseInt(featWidth/perRow) - padding * 2;
	var tileHeight = tileWidth * .60; 
	// if (perRow === 1) {
	// 	tileHeight = tileWidth * 4;
	// } else {
	// 	tileHeight = tileWidth * .75;
	// }

	// alert("W: " + featWidth + " " + tileWidth + " H: " + featHeight + " " + tileHeight);
	$('#' + name).css({
		"background-image":'url(' + img + ')',
		"background-position":"center",
		"background-size":"cover",
		// "width":tileWidth + 'px',
		"width":"100%",
		"height":tileHeight + 'px'
	});
}