//= require jquery
//= require jquery_ujs
//= require bootstrap/dist/js/bootstrap
//= require jquery.validation/dist/jquery.validate.js
//= require ScrollMagic/js/jquery.scrollmagic.min.js
//= require jquery.cookie/jquery.cookie.js
//= require frontend/animations


$(document).ready(function() {
  Devise = {
    init: function() {
      $('#js-change-price').on('click', Devise.change_price);
      $('.sign-in-form').on('ajax:success', Devise.sign_in_success);
      $('.sign-up-form').on('ajax:success', Devise.sign_up_success);
      $('.simple_form').on('ajax:error', Devise.form_error);
    },
    change_price: function() {
      cur_currency = $('.tag-currency').text();
      cur_int = $('.tag-price').text();
      cur_cents = $('.tag-cents').text();
      $('.tag-currency').text($(this).data('switch-currency'));
      $('.tag-price').text($(this).data('switch-int'));
      $('.tag-cents').text($(this).data('switch-cents'));
      $(this).data('switch-int', cur_int);
      $(this).data('switch-currency', cur_currency);
      $(this).data('switch-cents', cur_cents);

      cur_text = $(this).text();
      $(this).text( $(this).data('text'));
      $(this).data('text', cur_text);
    },
    sign_in_success: function() {
      window.location.href = '/user';
    },
    sign_up_success: function() {
      window.location.href = '/user/complete_signup';
    },
    form_error: function() {
      $('#js-form-error').fadeIn(700);
    }
  };
  Cookies = {
    init: function() {
      $('#js-cookie-btn').on('click', Cookies.click);
      if(!$.cookie('cookie-msg')){
        $('#js-cookie-msg').addClass('animated fadeInUp').show();
      }
    },
    click: function() {
      $('#js-cookie-msg').addClass('animated fadeOutUp');
      $.cookie('cookie-msg', 'accepted', { expires: 1000 });
    }
  }
  if($('body').hasClass('home')){
   Animations.init();
 }else {
   Devise.init();


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
