(function ($, ProductDemoPage, undefined) {

  var opts = {pages: ['cc', 'paypal', 'download']};
  ProductDemoPage.init = function() {
    ProductDemoPage.Events.init();
    ProductDemoPage.Form.init();
    opts.productId = $('#js-checkout-tab').data('product-id');
    ProductDemoPage.Social.init();
    $('.pay-download-btn').on('click', function(){
      var num =  parseInt($('.js-download-counter').first().text(), 10);
      if(num == 0) {
       $('.pay-download-btn').prop("href", '#')
       return false;
     }
     $('.js-download-counter').text(num - 1);
   });
  };

  ProductDemoPage.Social = {
    init: function() {
      var url = document.URL;
      var facebookCount = 'https://graph.facebook.com/fql?q=SELECT share_count FROM link_stat WHERE url="' + url + '"';
      $.getJSON( facebookCount, {
      })
      .done(function( data ) {
        console.log(data.data)
        $('.fb-btn').find('.counter').text(data.data[0].share_count);
      });
    }
  }

  ProductDemoPage.Form = {
    init: function() {
      $('input.cc-cvc').payment('formatCardCVC');
      ProductDemoPage.Form.setValidation();
    },
    submit: function(event){
      ProductDemoPage.Animations.show_form_processing();
      window.setTimeout(ProductDemoPage.Form.success, 1500);
        return false;
      },


      success: function(data) {
       $('.downloads-box').removeClass('hidden');
       $('.l-unsubscribe').removeClass('hidden');
       $('.buy-box').addClass('hidden');
       ProductDemoPage.Animations.show_form_success();
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
      "cc-num" : { ccNumberValid : true,
        required: true
      },
      "cc-email": {
        required: true,
        email: true
      },
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
    $("#js-buy-btn").on('click', ProductDemoPage.Animations.show_buy_page);
    $("#js-close-buy").on('click', ProductDemoPage.Animations.show_product_page);
    $('.js-unsubscribe-order').on('click',  ProductDemoPage.Events.order_unsubscribe);
  }
};

ProductDemoPage.Animations = {
  show_buy_page: function() {
   ProductDemoPage.Animations.simulateCheckout();
   $('#product-page-wrapper').scrollTo('#js-product-modal', 800);
   ProductDemoPage.Animations.show_checkout_preview();
   $('#js-product').fadeTo(500, 0);
   $('#js-product').css('height',1);
   $('#js-product-modal').fadeTo(500, 1);

 },
 show_product_page: function() {
  $('#js-product').css('height','100%');
  $('#product-page-wrapper').scrollTo('#js-product', 800);
  $('#js-product').fadeTo(500, 1);
  $('#js-product-modal').fadeTo(500, 0);
},
show_checkout_preview: function() {
  if (polyClip.isOldIE) {
    jQuery(window).bind('load', polyClip.init);
  } else {
    jQuery(document).ready(polyClip.init);
  }
  var top_animations = 0;
  if ($(".top").css("padding-top") == "20px" ){
    top_animations = 28;
  }
  $(document).on("preview_draw", function() {
   $('.product-image').fadeIn(500);
   $('.payform-loading').fadeOut(1500);
   $('.checkout-preview').animate({top: top_animations}, 1000, function(){
    $('.checkout-title h1').fadeIn(400);
    $('.checkout-title h2').fadeIn(400);
  });
 });
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
show_form_success: function() {
  img = $(".pay-success-text img");
  img.prop('src', img.prop('src').replace(/\?.*$/,"")+"?x="+Math.random());
  $("#js-pay-btn .pay-btn-text").fadeOut(function() {
    $(this).html($('.pay-success-text').html());
    $("#js-pay-btn").addClass('pay-success-btn');
  }).fadeIn(500);
  window.setTimeout(  ProductDemoPage.Animations.show_download_tab, 1900 );
},
simulateCheckout: function(){
  console.log('ffi');
  window.setTimeout(function(){

   window.setTimeout(function(){
     $('input.cc-num').simulate("key-sequence",
      {sequence: '4111 1111 1111 1111', delay: 150});
   }, 800);

   window.setTimeout(function(){
     $('input.cc-exp').simulate("key-sequence",
      {sequence: '12/22', delay: 150});
   }, 4100);

   window.setTimeout(function(){

     $('input.cc-cvc').simulate("key-sequence",
      {sequence: '123', delay: 150});
   }, 5800);
 }, 1000);
}

};

ProductDemoPage.download = function() {
 ProductDemoPage.Modal.set('download');
 $('.btn-link-download').on('click', function(){
   rd =  parseInt($('#js-download-counts').text());
   $('#js-download-counts').text(rd > 0 ? rd - 1: rd )
 });
 $('#js-btn-buy').on('click', ProductDemoPage.Modal.open);
}

}(jQuery, window.ProductDemoPage = window.ProductDemoPage || {}));
