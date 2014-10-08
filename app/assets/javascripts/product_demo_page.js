(function ($, ProductDemoPage, undefined) {

  var opts = {pages: ['cc', 'paypal', 'download']};
  ProductDemoPage.init = function() {
    ProductDemoPage.Events.init();
    ProductDemoPage.Form.init();
  };


  ProductDemoPage.Form = {
    init: function() {
  $('input.cc-exp').payment('formatCardExpiry');
      $('input.cc-cvc').payment('formatCardCVC');
      ProductDemoPage.Animations.simulateCheckout();
      ProductDemoPage.Form.setValidation();
    },
    submit: function() {
      ProductDemoPage.Animations.show_form_processing();
      if( !$(".cc-email").val() ) {
        window.setTimeout(  ProductDemoPage.Animations.show_form_error, 3000 );
      }else{
        window.setTimeout(  ProductDemoPage.Animations.show_form_success, 3000 );
      }
      return false;
    },

    validationErrors: function(errorMap, errorList) {

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
 },
 setValidation: function() {
  jQuery.validator.addMethod("ccNumberValid", function(value, element) {
    return $.payment.validateCardNumber(value);
  }, " Credit Card Number is Invalid.");
  jQuery.validator.addMethod("ccExpValid", function(value, element) {
    data = $.payment.cardExpiryVal(value);
    return $.payment.validateCardExpiry(data.month, data.year);
  }, " Credit Card Data is Invalid.");

  $('#js-checkout-form').validate({
    submitHandler: ProductDemoPage.Form.submit,
    rules : {
      "cc-num" : {
        required: true
      },
      //"cc-email": {
      //  required: true,
      //  email: true
     // },
      "cc-exp": {
        required: true,
        ccExpValid: true
      },
      "cc-cvc": {
        required: true,
        digits: true,
        minlength: 3,
        maxlength: 4
      }
    },
    showErrors: ProductDemoPage.Form.validationErrors
  });
}
};

ProductDemoPage.Events = {
  init: function() {
    $("#js-coupon-btn").on('click', ProductDemoPage.Animations.show_coupon_form);
    $("#js-buy-btn").on('click', ProductDemoPage.Animations.show_buy_page);
    $("#js-paypal-btn").on('click', ProductDemoPage.Animations.show_paypal_processing);
    $("#js-close-buy").on('click', ProductDemoPage.Animations.show_product_page);
    $("#js-coupon-apply").on('submit', ProductDemoPage.Events.couponApply);
  }
};

ProductDemoPage.Animations = {
   show_buy_page: function() {
    $(".product-modal").slideUp(400, 'swing');
    $(".product-page-buy").slideDown(400, 'swing');
    if (polyClip.isOldIE) {
      jQuery(window).bind('load', polyClip.init);
    } else {
      jQuery(document).ready(polyClip.init);
    }
    $(document).on("preview_draw", function() {
       $('.product-image').fadeIn(500);
      $('.payform-loading').fadeOut(1500);
      $('.checkout-preview').animate({top: 0}, 1000, function(){
        $('.checkout-title h1').fadeIn(400);
       $('.checkout-title h2').fadeIn(400);
     });
    });
  },
  show_product_page: function() {
    $(".product-modal").slideDown(400, 'swing');
    $(".product-page-buy").slideUp(400, 'swing');
  },
  show_download_tab: function() {
    $("#js-product-download-tab").slideDown(400, 'swing');
    $("#js-product-pay-tab").slideUp(400, 'swing');
  },
  show_form_processing: function() {
    img = $(".processing-text img");
    img.prop('src', img.prop('src').replace(/\?.*$/,"")+"?x="+Math.random());
    $("#js-pay-btn .pay-btn-text").fadeOut(function() {
      $(this).html($('.processing-text').html());
    }).fadeIn(500);
    $("#js-pay-btn").prop('disabled', true);
  },
  show_paypal_processing: function() {
    $("#js-paypal-btn .paypal-btn-text").fadeOut(function() {
      $('.paypal-processing-text').fadeIn(500);
    });
    $("#js-paypal-btn").prop('disabled', true);
  },
  show_form_success: function() {
    img = $(".pay-success-text img");
    img.prop('src', img.prop('src').replace(/\?.*$/,"")+"?x="+Math.random());
    $("#js-pay-btn .pay-btn-text").fadeOut(function() {
      $(this).html($('.pay-success-text').html());
      $("#js-pay-btn").addClass('pay-success-btn');
    }).fadeIn(500);
    window.setTimeout(  ProductDemoPage.Animations.show_download_tab, 1900 );
  },
  show_form_error: function() {
   $("#js-pay-btn .pay-btn-text").fadeOut(function() {
    $(this).html($('.pay-error-text').html());
    $("#js-pay-btn").addClass('pay-error-btn');
  }).fadeIn(500);
   window.setTimeout(function(){
     $("#js-pay-btn .pay-btn-text").fadeOut(function() {
      $(this).html($('.pay-text').html());
      $("#js-pay-btn").prop('disabled', false);
      $("#js-pay-btn").removeClass('pay-error-btn');
    }).fadeIn(500);
   }, 3500 );
 },
 show_coupon_form: function() {
  $("#js-coupon-form").slideDown(300);
  $("#js-coupon-btn").slideUp(300);
},
show_coupon_form_success: function() {
  $(".coupon-accepted").slideDown(400);
  $(".coupon-label").fadeIn(400);
  $("#js-coupon-btn").slideUp(400);
},
show_coupon_form_error: function() {
  $(".coupon-invalid").slideDown(400);
  $("#js-coupon-btn").slideUp(400);
  window.setTimeout(function(){
    $(".coupon-invalid").slideUp(400);
    $("#js-coupon-form").slideDown(400);
  }, 1500);
},
simulateCheckout: function(){
 window.setTimeout(function(){

   window.setTimeout(function(){
     $('input.cc-num').simulate("key-sequence",
      {sequence: '4111 1111 1111 1111', delay: 200});
   }, 1300);

   window.setTimeout(function(){
     $('input.cc-exp').simulate("key-sequence",
      {sequence: '120', delay: 200});
   }, 5200);

   window.setTimeout(function(){

     $('input.cc-cvc').simulate("key-sequence",
      {sequence: '123', delay: 200});
   }, 6400);
 }, 1000);
}
};


}(jQuery, window.ProductDemoPage = window.ProductDemoPage || {}));
