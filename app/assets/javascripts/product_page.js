(function ($, ProductPage, undefined) {

  var opts = {pages: ['cc', 'paypal', 'download']};
  ProductPage.init = function() {
    ProductPage.Events.init();
    ProductPage.Form.init();
    // buy, buyPaypal, download, afterPaypal
    //opts.action = $('#js-modal').data('action');
    opts.productId = $('#js-checkout-tab').data('product-id');
   // opts.paypal = $('#js-modal').data('paypal');
   // opts.paypal = false;
   //ProductPage[opts.action]();
   ProductPage.Social.init();
    $('.pay-download-btn').on('click', function(){
  var num =  parseInt($('.js-download-counter').first().text(), 10);
  console.log(num);
   if(num == 0) {
     $('.pay-download-btn').prop("href", '#')
     return false;
   }
   $('.js-download-counter').text(num - 1);
 });
 };

 ProductPage.Social = {
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

ProductPage.Form = {
  init: function() {
    $('input.cc-num').payment('formatCardNumber');
    $('input.cc-exp').payment('formatCardExpiry');
    $('input.cc-cvc').payment('formatCardCVC');
    ProductPage.Form.setValidation();
  },
  submit: function(event){
    ProductPage.Animations.show_form_processing();
    cc_num = $('input.cc-num').val().replace(/\s+/g, '');
    cc_exp = $('input.cc-exp').payment('cardExpiryVal')
    cc_cvc = $('input.cc-cvc').val();
    product = ProductPage.Form.productInfo();
    ProductPage.Form.token(cc_num, cc_exp, cc_cvc, product.price, product.currency,
      ProductPage.Form.pay)
    return false;
  },
  productInfo: function() {
   product = {};
   $.ajax({
    url: '/checkout/pay_info',
    type: 'GET',
    dataType: 'json',
    data: {product_id: opts.productId},
    async: false,
    success: function(d) { product = d }
  });
   return product;
 },
 token: function(cc_num, cc_exp, cc_cvc, amount, currency, response) {
  paymill.createToken({
    number:         cc_num,
    exp_month:      cc_exp.month,
    exp_year:       cc_exp.year,
    cvc:            cc_cvc,
    amount_int:     amount,
    currency:       currency
  },
  response);
},
pay: function(error, result) {
  $.ajax({
    url: '/checkout/pay',
    type: 'POST',
    dataType: 'json',
    data: {product_id: opts.productId,
      token: result.token,
      email: $('input.cc-email').val()},
      success: ProductPage.Form.success,
      error: ProductPage.Form.error
    });
},
success: function(data) {
 $('.js-unsubscribe-order').data('token', data.token);
 $('.pay-download-btn').attr("href", data.url);
 $('.downloads-box').removeClass('hidden');
 $('.l-unsubscribe').removeClass('hidden');
 $('.buy-box').addClass('hidden');

 ProductPage.Animations.show_form_success();
},
error: function(d) {
  ProductPage.Animations.show_form_error();
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
    submitHandler: ProductPage.Form.submit,
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
    showErrors: ProductPage.Form.validationErrors
  });
}
};

ProductPage.Events = {
  init: function() {
    $("#js-coupon-btn").on('click', ProductPage.Animations.show_coupon_form);
    $("#js-buy-btn").on('click', ProductPage.Animations.show_buy_page);
    $("#js-paypal-btn").on('click', ProductPage.Paypal.request);
    $("#js-close-buy").on('click', ProductPage.Animations.show_product_page);
    $("#js-coupon-apply").on('submit', ProductPage.Events.couponApply);
    $('.js-unsubscribe-order').on('click',  ProductPage.Events.order_unsubscribe);
    $('#js-buy-paypal-btn').on('click', ProductPage.Paypal.buy_request);
  },
  order_unsubscribe: function(){
    $.ajax({
      url: '/checkout/unsubscribe_order_updates',
      type: 'POST',
      dataType: 'json',
      data: {token:  $('.js-unsubscribe-order').data('token')},
      async: true,
      success: function(d) {
        $('.js-unsubscribe-order').fadeOut().text('Unsubscribed from product updates').addClass('disabled').fadeIn();
      }
    });
  },
  couponApply: function(){

    if($('input.coupon-code').val()){
      ProductPage.Animations.show_coupon_form_success();
    }else
    {
      ProductPage.Animations.show_coupon_form_error();
    }
    return false;
  }
};

ProductPage.Animations = {
  show_buy_page: function() {

    $('#product-page-wrapper').scrollTo('#js-product-modal', 800);
    ProductPage.Animations.show_checkout_preview();
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
    window.setTimeout(  ProductPage.Animations.show_download_tab, 1900 );
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
}
};


ProductPage.download = function() {
 ProductPage.Modal.set('download');
 $('.btn-link-download').on('click', function(){
   rd =  parseInt($('#js-download-counts').text());
   $('#js-download-counts').text(rd > 0 ? rd - 1: rd )
 });
 $('#js-btn-buy').on('click', ProductPage.Modal.open);
}


ProductPage.Paypal = {
  request: function() {
    ProductPage.Animations.show_paypal_processing();
    $.ajax({
      url: '/checkout/paypal',
      type: 'POST',
      dataType: 'json',
      data: {product_id:  opts.productId},
      async: true,
      success: function(d) {
        window.location.replace(d.url)
      },
      error: function() {
        ProductPage.Modal.close();
      }
    });
    return  false;
  },
  buy_request: function() {
    $('#js-buy-paypal-btn').text('Contacting Paypal...')
    $.ajax({
      url: '/checkout/paypal',
      type: 'POST',
      dataType: 'json',
      data: {product_id:  opts.productId},
      async: true,
      success: function(d) {
        window.location.replace(d.url)
      },
      error: function() {
        ProductPage.Modal.close();
      }
    });
    return  false;
  }
}


}(jQuery, window.ProductPage = window.ProductPage || {}));
