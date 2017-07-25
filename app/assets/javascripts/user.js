

$(document).ready( function() {

  $("#follow").change(function (){

    if(document.getElementById('follow').checked) {
      console.log("follow!");
    } else {
      console.log("unfollow!");
    }

    $(".profileForm").submit();
  });
});
