(function ($, ProductPage, undefined) {

  var opts = {
    height: 348,
    modal: {
      options: {
        url: '#js-modal',
        width: 315,
        effect: 'slide',
        position: 'bottom',
        speed:          600
      },
      pages: ['cc', 'paypal', 'download']
    }};

    ProductPage.init = function() {
    // buy, buyPaypal, download, afterPaypal
    //opts.action = $('#js-modal').data('action');
    //opts.productId = $('#js-modal').data('product-id');
   // opts.paypal = $('#js-modal').data('paypal');
   // opts.paypal = false;
   //ProductPage[opts.action]();
   $("#js-coupon-btn").on('click', ProductPage.Animations.show_coupon_form);
   $("#js-coupon-apply").on('click', ProductPage.Animations.show_coupon_form_success);
   $("#js-buy-btn").on('click', ProductPage.Animations.show_buy_page);
   $("#js-close-buy").on('click', ProductPage.Animations.show_product_page);
   $('#js-checkout-form').on('submit', function(){
    ProductPage.Animations.show_form_processing();
    if( $(".cc-num").val() ) {
      window.setTimeout(  ProductPage.Animations.show_form_error, 3000 );
    }else{
      window.setTimeout(  ProductPage.Animations.show_form_success, 3000 );
    }
    return false;
  });

   $('input.cc-num').payment('formatCardNumber');
   $('input.cc-exp').payment('formatCardExpiry');
   $('input.cc-cvc').payment('formatCardCVC');
 //  ProductPage.Form.setValidation();
}

ProductPage.Animations = {
  show_buy_page: function() {
    $(".product-modal").slideUp(400, 'swing');
    $(".product-page-buy").slideDown(400, 'swing');
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
    }).fadeIn(400);
    $("#js-pay-btn").prop('disabled', true);
  },
  show_form_success: function() {
    img = $(".pay-success-text img");
    img.prop('src', img.prop('src').replace(/\?.*$/,"")+"?x="+Math.random());
    $("#js-pay-btn .pay-btn-text").fadeOut(function() {
      $(this).html($('.pay-success-text').html());
    }).fadeIn(400);
    $("#js-pay-btn").addClass('pay-success-btn');
    window.setTimeout(  ProductPage.Animations.show_download_tab, 1400 );
  },
  show_form_error: function() {
   $("#js-pay-btn .pay-btn-text").fadeOut(function() {
    $(this).html($('.pay-error-text').html());
  }).fadeIn(400);
   $("#js-pay-btn").addClass('pay-error-btn');
   window.setTimeout(function(){
     $("#js-pay-btn .pay-btn-text").fadeOut(function() {
      $(this).html($('.pay-text').html());
      $("#js-pay-btn").prop('disabled', false);
    }).fadeIn(400);
     $("#js-pay-btn").removeClass('pay-error-btn');
   }, 3500 );
 },
 show_coupon_form: function() {
  $("#js-coupon-form").slideDown(300);
  $("#js-coupon-btn").slideUp(300);
},
show_coupon_form_success: function() {
  $("#js-coupon-form").slideUp(300);
  $("#js-coupon-btn").slideDown(300);
}
};



ProductPage.buy = function() {
 ProductPage.Modal.set('cc');
 $('#js-btn-buy').on('click', ProductPage.Form.open);
}
ProductPage.buyPaypal = function() {
 ProductPage.Modal.set('paypal');
 $('#js-btn-buy').on('click', ProductPage.Paypal.open);
}
ProductPage.afterPaypal = function() {
 ProductPage.Modal.open();
 ProductPage.Modal.set('download', true);
 $('#js-btn-buy').on('click', ProductPage.Modal.open);
}
ProductPage.download = function() {
 ProductPage.Modal.set('download');
 $('.btn-link-download').on('click', function(){
   rd =  parseInt($('#js-download-counts').text());
   $('#js-download-counts').text(rd > 0 ? rd - 1: rd )
 });
 $('#js-btn-buy').on('click', ProductPage.Modal.open);
}

ProductPage.Modal = {
  set: function(page, noAnimation) {
    for (i = 0; i < opts.modal.pages.length; ++i) {
     var height = ((opts.modal.pages[i] == page) ? opts.height : 0);

     if(noAnimation == true) {
      $('#' + opts.modal.pages[i]).height(height);
    }else{
     $('#' + opts.modal.pages[i]).transition({height: height + 'px', queue: false},
      600, 'easeInOutQuart');
   }
 }
},
open: function() {
  $.fn.custombox(opts.modal.options);
  if(opts.paypal == false) {
    $('#cc').height(250);
  }
  return false;
},
close: function() {
  $.fn.custombox('close');
}

}

ProductPage.Form = {
  open: function() {
    ProductPage.Modal.open();
    $('input.cc-num').payment('formatCardNumber');
    $('input.cc-exp').payment('formatCardExpiry');
    $('input.cc-cvc').payment('formatCardCVC');
    ProductPage.Form.setValidation();
    $(document).on('click','#js-btn-paypal', ProductPage.Paypal.request);
    return false;
  },
  submit: function(event){

    return false
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
    data: {product_id: $('.buy-form').data('product-id'),
    token: result.token,
    email: $('input.cc-email').val()},
    success: ProductPage.Form.success,
    error: ProductPage.Form.error
  });
},
success: function(data) {
 $('.js-btn-pay').each(function(){ this.disabled = false; });
 $('.btn-buy').hide();
 $('.cc-error').hide();
 $('.btn-download').removeClass('hidden');
 $('.btn-download').prop("href", data.url);
 ProductPage.Modal.set('download');
},
error: function(d) {
 $('.js-btn-pay').each(function(){ this.disabled = false;});
 $('.processing').hide();
 $('.message').hide();
 $('.cc-error').show();
},
validationErrors: function(errorMap, errorList) {

  $.each(this.validElements(), function (index, element) {
    var $element = $(element);
    $element.data("title", "")
    .tooltip("destroy");
    $element.parent().removeClass("has-error");
  });
   // Create new tooltips for invalid elements
   $.each(errorList, function (index, error) {
    var $element = $(error.element);
    $element.tooltip("destroy")
    .data("title", error.message)
    .data("placement", "bottom")
    .tooltip();
    $element.parent().addClass("has-error");
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

  $('#cc-form').validate({
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
}

ProductPage.Paypal = {
  open: function() {
    ProductPage.Modal.open();
    ProductPage.Paypal.request();
  },
  request: function() {
    ProductPage.Modal.set('paypal');
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
