function keywordsFromImage(evt) {
	// automatically examine an image for its dominant colors
	// and aspect ratio descriptor (portrait/landscape/square/panoramic).
	// pass all of them as a parameter keyword string when the form submits
	//
	var keywordStr = plpansq(evt.target.id);
	keywordStr += " " + getColorStringFromImage(evt);

	// retrieve number from target id:
	var num = evt.target.id.match(/\d/);

	// construct correct hidden field id and set its value
	document.getElementById("keywordStr" + num).value = keywordStr;
}

function plpansq (img) {
	// test if an image is portrait, landscape, panoramic, or square.
	// parameter img is assumed to be the id of an image element
	var image = document.getElementById(img);
	var nh = image.naturalHeight, nw = image.naturalWidth;
	var aspect = nw/nh, retStr = "portrait";

	if (aspect >= 2) {
		retStr = "panoramic";
	} else if (aspect > 1.1 ) {
		retStr = "landscape";
	} else if (aspect > 0.9) {
		retStr = "square";
	}

	return retStr;
}

function getColorStringFromImage(evt) {
	// return a string of space-separated dominating colors from
	// the image associated with a file selector on an image upload
	//
	var keywordStr = "", color = "", colorArray = [];

	lmnt = document.getElementById(evt.target.id);
	var cf = new ColorFinder();
	var rgb = cf.getMostProminentColor(lmnt);

	color = parseInt(rgb.r).toString(16) + parseInt(rgb.g).toString(16) + parseInt(rgb.b).toString(16);
	colorArray.push(color);

	rgb = new ColorFinder(favorHue).getMostProminentColor(lmnt);
	color = parseInt(rgb.r).toString(16) + parseInt(rgb.g).toString(16) + parseInt(rgb.b).toString(16);
	if (!colorArray.includes(color)) {
		colorArray.push(color);
	}

	rgb = new ColorFinder(favorBright).getMostProminentColor(lmnt);
	color = parseInt(rgb.r).toString(16) + parseInt(rgb.g).toString(16) + parseInt(rgb.b).toString(16);
	if (!colorArray.includes(color)) {
		colorArray.push(color);
	}

	rgb = new ColorFinder(favorDark).getMostProminentColor(lmnt);
	color = parseInt(rgb.r).toString(16) + parseInt(rgb.g).toString(16) + parseInt(rgb.b).toString(16);
	if (!colorArray.includes(color)) {
		colorArray.push(color);
	}

	rgb = new ColorFinder(excludeWhite).getMostProminentColor(lmnt);
	color = parseInt(rgb.r).toString(16) + parseInt(rgb.g).toString(16) + parseInt(rgb.b).toString(16);
	if (!colorArray.includes(color)) {
		colorArray.push(color);
	}

	rgb = new ColorFinder(excludeBlack).getMostProminentColor(lmnt);
	color = parseInt(rgb.r).toString(16) + parseInt(rgb.g).toString(16) + parseInt(rgb.b).toString(16);
	if (!colorArray.includes(color)) {
		colorArray.push(color);
	}

	rgb = new ColorFinder(favorBrightExcludeWhite).getMostProminentColor(lmnt);
	color = parseInt(rgb.r).toString(16) + parseInt(rgb.g).toString(16) + parseInt(rgb.b).toString(16);
	if (!colorArray.includes(color)) {
		colorArray.push(color);
	}

	keywordStr = colorArray.join(" ");
	return keywordStr;

}

function handleFileSelect(evt) {
	var files = evt.target.files; // FileList object
	f=files[0];
	// Only process image files.
	if (f.type.match('image.*')) {
		var reader = new FileReader();
		reader.onload = (function(theFile) {
			return function(e) {
				// alert(e.target.result);
				document.getElementById(evt.target.id + "_prev").src=e.target.result;
				document.getElementById(evt.target.id + "_prev").style.visibility = "visible";
			};
		})(f);

		// Read in the image file as a data URL.
		reader.readAsDataURL(f);

	}
} 


