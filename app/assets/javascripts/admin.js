$(document).ready(function(){
	$.fn.peity.defaults.line = {
		colour: "#c6d9fd",
		strokeColour: "#4d89f9",
		strokeWidth: 1,
		delimiter: ",",
		height: 38,
		max: null,
		min: 0,
		width: 200
	}
	$(".line").peity("line")
	$( ".product-stats-cell" ).hover(
  function() {
    $( this ).addClass( "hover" );
  }, function() {
    $( this ).removeClass( "hover" );
  }
);

});

   function showAlert(type, message){
         $('.alert-box')
         .html('<div class="alert alert-'+ type + '"><a class="close" data-dismiss="alert">×</a><span>'+message+'</span></div>');
    }