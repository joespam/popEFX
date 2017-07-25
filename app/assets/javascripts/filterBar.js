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
//= require_tree .

// function to toggle visibility of the
// landing page filter bar, and swap the icon
// of the hide/show button accordingly between
// fa-plus and fa-minus
//
$(function() {
  $('#filterBtn').click(function(event){
     event.preventDefault();

     // swap icon from + to - or vice-versa
    // var btnClass = document.getElementsByClassName("fa fa-plus");

    var icon = document.getElementById("filterIcon");
    var iconClass = icon.className;

    if(iconClass === "fa fa-plus") {
      icon.className = "fa fa-minus";
    } else {
      icon.className = "fa fa-plus";
    }

    // toggle visibility
    $('div.filter').toggle();
  });

  $('#filterSubmitBtn').click(function() {

    // get values of all selected checkboxes
    var checkedValues = $('.filterBar:checked').map(function() {
      return this.value;
    }).get();

    // alert(checkedValues);
    // alert(thing + " !!!");
    document.getElementById("srchterm").value = checkedValues;

    // get color picker value
    var thong = $('#flat').get();
    // alert(thong);

    // submit search
    $("#searchForm").trigger("submit.rails");
  });

  $( "input.filterBar" ).change(function() {
    if(this.checked) {
      // add value to search bar
      //
      document.getElementById("srchterm").value += " " + this.value;

    } else {
      // remove value from search bar
      //
      var currentVal = document.getElementById("srchterm").value;
      if (currentVal.toLowerCase().indexOf(this.value.toLowerCase()) != -1){
        document.getElementById("srchterm").value = currentVal.replace(" " + this.value, "");
      }
    }
  });

  $("#palleteChk").change(function() {

    if(this.checked) {
      // make the colorpicker clickable
      //
      // $(".srchColorPicker").css();

    } else {
      // remove value from search bar
      //
      // $(".srchColorPicker").css();
    }
  });
});
