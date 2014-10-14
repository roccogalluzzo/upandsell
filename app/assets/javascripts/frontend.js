//= require jquery
//= require jquery_ujs
//= require bootstrap/dist/js/bootstrap
//= require jquery.validation/jquery.validate.js
//= require ScrollMagic/js/jquery.scrollmagic
//= require jquery.cookie/jquery.cookie.js
//= require frontend/animations


$(document).ready(function() {

  $('#js-cookie-btn').on('click', function(){
    $('#js-cookie-msg').addClass('animated fadeOutUp');
    $.cookie('cookie-msg', 'accepted', { expires: 1000 });
  });

  if(!$.cookie('cookie-msg')){
    $('#js-cookie-msg').addClass('animated fadeInUp').show();
  }

  if($('body').hasClass('home')){

   $(".invite").on("ajax:success", function(e, data, status, xhr){
    $(".invite").slideUp();
    $("#js-beta-invite-sent").show().slideDown();
    ga('send', 'event', 'form', 'beta_requested');
  });
   $(".invite").on("ajax:error", function(e, data, status, xhr){
     $(".form-error p").text(data.responseJSON.msg);
     $(".form-error").removeClass('hidden-animation').addClass('animated fadeInUp').css('visibility', 'visible');
     setTimeout(function(){ $('.form-error').removeClass('animated fadeInUp').css('visibility', 'hidden');},3000);
   });
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
 }else {
   $(".simple_form").validate({ showErrors: function(errorMap, errorList) {
    $.each(this.validElements(), function (index, element) {
      var $element = $(element);
      $element.data("title", "")
      .tooltip("destroy");
      $element.removeClass("has-error");
    });

    $.each(errorList, function (index, error) {
      var $element = $(error.element);
      $element.tooltip("destroy")
      .data("title", error.message)
      .data("placement", "bottom")
      .tooltip();
      $element.addClass("has-error");
    });

  }});

 }
});
