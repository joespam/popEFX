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
//= require masonry/jquery.masonry
//= require spectrum
//= require_tree .

// create the ability to catch resize events on specific elements.
//	Usage:
//		var myElement = document.getElementById('my_element'),
//		   myResizeFn = function(){
//		      /* do something on resize */
//		   };
//		addResizeListener(myElement, myResizeFn);
//		removeResizeListener(myElement, myResizeFn);

(function(){
  var attachEvent = document.attachEvent;
  var isIE = navigator.userAgent.match(/Trident/);
  // console.log(isIE);
  var requestFrame = (function(){
    var raf = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame ||
        function(fn){ return window.setTimeout(fn, 20); };
    return function(fn){ return raf(fn); };
  })();
  
  var cancelFrame = (function(){
    var cancel = window.cancelAnimationFrame || window.mozCancelAnimationFrame || window.webkitCancelAnimationFrame ||
           window.clearTimeout;
    return function(id){ return cancel(id); };
  })();
  
  function resizeListener(e){
    var win = e.target || e.srcElement;
    if (win.__resizeRAF__) cancelFrame(win.__resizeRAF__);
    win.__resizeRAF__ = requestFrame(function(){
      var trigger = win.__resizeTrigger__;
      trigger.__resizeListeners__.forEach(function(fn){
        fn.call(trigger, e);
      });
    });
  }
  
  function objectLoad(e){
    this.contentDocument.defaultView.__resizeTrigger__ = this.__resizeElement__;
    this.contentDocument.defaultView.addEventListener('resize', resizeListener);
  }
  
  window.addResizeListener = function(element, fn){
    if (!element.__resizeListeners__) {
      element.__resizeListeners__ = [];
      if (attachEvent) {
        element.__resizeTrigger__ = element;
        element.attachEvent('onresize', resizeListener);
      }
      else {
        if (getComputedStyle(element).position == 'static') element.style.position = 'relative';
        var obj = element.__resizeTrigger__ = document.createElement('object'); 
        obj.setAttribute('style', 'display: block; position: absolute; top: 0; left: 0; height: 100%; width: 100%; overflow: hidden; pointer-events: none; z-index: -1;');
        obj.__resizeElement__ = element;
        obj.onload = objectLoad;
        obj.type = 'text/html';
        if (isIE) element.appendChild(obj);
        obj.data = 'about:blank';
        if (!isIE) element.appendChild(obj);
      }
    }
    element.__resizeListeners__.push(fn);
  };
  
  window.removeResizeListener = function(element, fn){
    element.__resizeListeners__.splice(element.__resizeListeners__.indexOf(fn), 1);
    if (!element.__resizeListeners__.length) {
      if (attachEvent) element.detachEvent('onresize', resizeListener);
      else {
        element.__resizeTrigger__.contentDocument.defaultView.removeEventListener('resize', resizeListener);
        element.__resizeTrigger__ = !element.removeChild(element.__resizeTrigger__);
      }
    }
  }
})();

// 
//  featureFit
//		given element id <name>, an img <img>, and the number of images
//		per row <perRow>, set the backgraound css properties of name to img 
//    (future) Watermark true by default.
//
function featureFit(name,img,perRow,watermark) {

  // watermark should default to true
  if (typeof watermark == 'undefined') {
    watermark = true;
  }

	// get width and height of featured div
	var featWidth = $('#featured').css("width");
	var featHeight = $('#featured').css("height");
	featWidth = parseInt(featWidth);
	featHeight = parseInt(featHeight);
	var padding = $('#' + name).css("padding");
	padding = parseInt(padding);

	// smallest featured tile has width = 1/4 of featured's and height 1/4
	var tileWidth = parseInt(featWidth/perRow) - padding * 2;
	var tileHeight; 
	if (perRow === 1) {
		tileHeight = tileWidth * .45;
	} else {
		tileHeight = tileWidth * .65;
	}

	// alert("W: " + featWidth + " " + tileWidth + " H: " + featHeight + " " + tileHeight);
	$('#' + name).css({
		"background-image":'url(' + img + ')',
		"background-position":"center",
		"background-size":"cover",
		// "width":tileWidth + 'px',
		"width":"96.5%",
		"height":tileHeight + 'px'
	});

  if (watermark) {
    // console.log("watermark #" + name + " with retrieved hidden image source.");
    // markImg(img,'#' + name, false);
  } else {
    // $('#' + name).css({
    //   "background-image":'url(' + img + ')'
    // });
  }

	if (perRow > 1) {
		$('#' + name).css("margin","4px");
	}
}

// 
// 	limitHeight
// 		Given divs of id's of 'first' and 'second', if first.height not equal
//      to second.height, set first.height = second.height
// 		

function limitHeight(first,second) {
	var fh = $('#' + first).outerHeight();
	var sh = $('#' + second).outerHeight();
  
	if(fh !== sh) {
	    $('#' + first).height(sh);
	} 
}

// given an element that has a single img element child with a valid 
// src, return the source of that image. Used in watermarking.
//
function getImgSrc(elemID) {
  var imgElem = document.getElementById(elemID).getElementsByTagName('img')[0];
  alert(imgElem);
}  

// given an element, set the height to the size of the window, minus
// the margin in Px.
//
function limitElementHeightToWindow(elemID,marginPx) {
    $(elemID).css({ height: $(window).innerHeight() - marginPx });
}

// Given an html setup with a parent Div of class divClass and a child
// child img of class childImgClass, sets the size of the image and adds
// a resize listener to the div that sizes the image on window changes.
//
function divImgSetSize(divClass,childImgClass) {
  $('.' + childImgClass).css({
    'max-width': $(window).width() - 100,
    'max-height': $(window).height() - 300  
  });
}

//
//  Create an image element as a child of the heroImage div.
//  This div exists solely for the purpose of placing a hero image
//  on an artist's profile page.
//
function setHeroImage(image) {
  var elem = document.createElement("img");
  elem.src = image
  document.getElementById("heroImage").appendChild(elem);
}
