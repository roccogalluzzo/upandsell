//= require jquery
//= require jquery_ujs
//= require bootstrap/dist/js/bootstrap
//= require jquery.validation/jquery.validate.js
//= require ScrollMagic/js/jquery.scrollmagic
//= require ScrollMagic/js/jquery.scrollmagic.debug.js
//= require frontend/animations


$(document).ready(function() {

 $(".invite").on("ajax:success", function(e, data, status, xhr){
    $(".invite-form").slideUp();
  $("#js-beta-invite-sent").show().slideDown();

});
 $(".invite").on("ajax:error", function(e, data, status, xhr){
 $(".form-error p").text(data.responseJSON.msg);
 $(".form-error").addClass('animated SlideUp').css('visibility', 'visible');
 setTimeout(function(){  $('.form-error').addClass('hidden-animation');},4000);
});



 $(".sign-form").validate({ showErrors: function(errorMap, errorList) {
  $.each(this.validElements(), function (index, element) {
    var $element = $(element);
    $element.data("title", "")
    .tooltip("destroy");
    $element.removeClass("has-error");
  });
   // Create new tooltips for invalid elements
   $.each(errorList, function (index, error) {
    var $element = $(error.element);
    $element.tooltip("destroy")
    .data("title", error.message)
    .data("placement", "bottom")
    .tooltip();
    $element.addClass("has-error");
  });
 }});
 $(".invite").validate({ showErrors: function(errorMap, errorList) {
  $.each(this.validElements(), function (index, element) {
    var $element = $(element);
    $element.data("title", "")
    .tooltip("destroy");
   // $element.removeClass("has-error animated swing fadeInUp");
  });
   // Create new tooltips for invalid elements
   $.each(errorList, function (index, error) {
    var $element = $(error.element);
    $element.tooltip("destroy")
    .data("title", error.message)
    .data("placement", "bottom")
    .tooltip();
 //   $('.beta-input').removeClass('animated swing fadeInUp');
 // setTimeout(function(){  $('.beta-input').addClass('animated swing');},200);

});
 }});
 Animations.init();

});
