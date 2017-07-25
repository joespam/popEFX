//
// calls code from watermark.js
//
// markimg marks an image URL 'picURL' with either a default
// or given watermark 'wmarkPath'. Conditional logic happens
// if elemID is an image element or a div, and also if the
// imgElement flag is set. imgElement is meant to be set to
//  false if
//    the structure of the image display is a div with a background image
//  true if
//     div with a child img element
//
function markImg (picURL,elemID,wmarkPath,imgElement) {

  if (typeof imgElement === 'undefined') {
    imgElement = true;
  }

  if (typeof wmarkPath === 'undefined') {
    wmarkPath = "";
  }
  // triggerID holds the ID of the element to trigger the
  // image change event on
  //
  var triggerID = elemID;
  var wmark = wmarkPath;
  if (wmark === "") {
    wmark = 'assets/watermark_temp.png';
  }

  var pieces = picURL.split('?');
  var img = pieces[0];

  if (imgElement) {

    watermark([img, wmark])
      .image(watermark.image.center(0.5))
      .then(function (img) {

        img.setAttribute('crossOrigin', 'anonymous');

          var lmnt = document.getElementById(elemID);
          if (lmnt.tagName === "IMG") {
            // get parent and reset html with img
            var parent = lmnt.parentElement
            var parentClass = parent.className;
            var imgClass = lmnt.className;

            // must set triggerID to be ID of parent
            triggerID = parent.id;

            // can't delete the original image without losing the resize listener,
            // which refuses to reattach if called from here, even in document.ready
            // parent.innerHTML = "";
            // so instead, set non-watermarked image to not display.
            img.className = imgClass;

          document.getElementById(triggerID).appendChild(img);

            // and set the image size
            $(document).ready( function() {
              divImgSetSize(parentClass,imgClass);
            });

          } else {

          // $(document).ready( function () {

              var div = document.getElementById(elemID);

              // if the div already has an image, delete it.
              //
              if (div.hasChildNodes()) {

                // elemID is expected to be of the form 'word_integer', so
                // determine the number so we can construct the image ID and
                // select it to remove it before we append the watermarked image
                //
                var i = elemID.replace( /^\D+/g, '');
                var oldImg = $('#boximg_' + i);
                if (typeof oldImg !== 'undefined') {
                  oldImg.remove();
                  img.id = 'boximg_' + i;
                }
              }

            var divRect = div.getBoundingClientRect();
            //
            // occasionally when this gets called, the div height is yet to be set
            // if so, hard code it to match the image's natural height scaled to
            // match the css-determined box width.
            //
            if(divRect.height === 0 ) {
              var scaledHeight = Math.ceil( img.naturalHeight * ( divRect.width / img.naturalWidth ) );
              // div.setAttribute("style","height:" + scaledHeight + "px");
              // $('#' + elemID).css({ height: scaledHeight + 'px' });
              div.style.height = scaledHeight + 'px';
            }

            div.appendChild(img);
          // });
        }

        // create a custom 'image marked' event
        // var myEvent = new CustomEvent("imgMarked", {
        //  detail: {
        //    element: triggerID
        //  }
        // });

        // // Trigger it!
        // document.getElementById(triggerID).dispatchEvent(myEvent);
      });

  } else {

    console.log("setting bkg");

    console.log("source: " + img);
    console.log("watermark: " + wmark);
    watermark([img, wmark])
      .image(watermark.image.center(0.5))
      // .then(function (img) {
      //   img.setAttribute('crossOrigin', 'anonymous');
      //   document.getElementById(elemID).css({
      //     "background-image":'url(' + img + ')'
      //   });
      // });
      // .then($(document).ready(function (img) {
      //  img.setAttribute('crossOrigin', 'anonymous');
      //  document.getElementById(elemID).css({
      //     "background-image":'url(' + img + ')'
      //  });
      // }));
      .then($(document).imagesLoaded(function (img) {
        // img.setAttribute('crossOrigin', 'anonymous');
        document.getElementById(elemID).css({
           "background-image":'url(' + img + ')'
        });
      }));
  }

}
