(function ($, PayForm, undefined) {


  PayForm.init = function() {
    validation();
    $('input.cc-num').payment('formatCardNumber');
    $('input.cc-exp').payment('formatCardExpiry');
    $('input.cc-cvc').payment('formatCardCVC');
  }

  function submit() {
    $('.btn-pay').attr('disabled', 'disabled');
    $('.processing').show();
    $('.message').show();
    cc_num = $('input.cc-num').val().replace(/\s+/g, '');
    cc_exp = $('input.cc-exp').payment('cardExpiryVal')
    cc_cvc = $('input.cc-cvc').val();
    product = getProductInfo($('.buy').data('product-id'));
    getToken(cc_num, cc_exp, cc_cvc, product.price, product.currency, pay)
    event.preventDefault();
  }

  function success(d) {
   $('.btn-pay').each(function(){
    this.disabled = false;
  });
   $('.processing').hide();
   $('.message').hide();

   if(d.status == 'failed'){
     $('.cc-error').show();

   }else{
    $('.btn-buy').hide();
    $('.cc-error').hide();
    $('.btn-download').removeClass('hidden');
    $.fn.custombox('close');
  }
}
function pay(error, result) {
  console.log(error, result);
  $.ajax({
    url: '/products/pay',
    type: 'POST',
    dataType: 'json',
    data: {product_id: $('.buy').data('product-id'),
    token: result.token,
    email: $('input.cc-email').val()},
    success: success
  });
}
function getProductInfo(id) {
 product = {};
 $.ajax({
  url: '/products/pay_info',
  type: 'GET',
  dataType: 'json',
  data: {product_id: id},
  async: false,
  success: function(d) { product = d }
});
 return product;
}
function validation() {
  jQuery.validator.addMethod("ccNumberValid", function(value, element) {
    return $.payment.validateCardNumber(value);
  }, " Credit Card Number is Invalid.");
  jQuery.validator.addMethod("ccExpValid", function(value, element) {
    data = $.payment.cardExpiryVal(value);
    return $.payment.validateCardExpiry(data.month, data.year);
  }, " Credit Card Data is Invalid.");

  $('#cc-form').validate({
    submitHandler: submit,
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
    showErrors: function(errorMap, errorList) {

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
        }
      });
}

PayForm.paypalInit = function() {
 $('.paypal').on('click', function ( e ) {

  $.fn.custombox( this, {
    width: 380,
    effect:         'slide',
    position: 'bottom',
    customClass:    'justme',
    speed:          100,
    open:  paypal($(this).data('product-id'))
  });


  e.preventDefault();
});
}
function paypal(id) {

  $.ajax({
    url: '/products/paypal',
    type: 'GET',
    dataType: 'json',
    data: {product_id: id},
    async: true,
    success: function(d) { window.location.replace(d.url) }
  });
}

function getToken(cc_num, cc_exp, cc_cvc, amount, currency, response){
  paymill.createToken({
    number:         cc_num,
    exp_month:      cc_exp.month,
    exp_year:       cc_exp.year,
    cvc:            cc_cvc,
    amount_int:     amount,
    currency:       currency
  },
  response);
}



}(jQuery, window.PayForm = window.PayForm || {}));
