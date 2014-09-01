//= require jquery
//= require jquery_ujs
//= require bootstrap/dist/js/bootstrap
//= require jquery.validation/jquery.validate.js
//= require ScrollMagic/js/jquery.scrollmagic
//= require ScrollMagic/js/jquery.scrollmagic.debug.js
//= require frontend/animations
$(document).ready(function() {
 $(".simple_form").validate({ showErrors: function(errorMap, errorList) {
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
 Animations.init();

});
