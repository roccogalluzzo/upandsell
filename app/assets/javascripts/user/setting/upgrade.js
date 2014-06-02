(function ($, UpgradePage, undefined) {



  UpgradePage.init = function() {

    UpgradePage.Form.init();
    window.PAYMILL_PUBLIC_KEY = '343945165162996b25976bec79666013'

  }


  UpgradePage.Form = {
    init: function() {
      $('input.cc-num').payment('formatCardNumber');
      $('input.cc-exp').payment('formatCardExpiry');
      $('input.cc-cvc').payment('formatCardCVC');
      UpgradePage.Form.setValidation();
    },

    submit: function(event){
      $('.js-btn-pay').attr('disabled', 'disabled');
      $('.processing').show();
      $('.message').show();
      cc_num = $('input.cc-num').val().replace(/\s+/g, '');
      cc_exp = $('input.cc-exp').payment('cardExpiryVal')
      cc_cvc = $('input.cc-cvc').val();
      amount = $('#cc-form').data('amount');
      currency = $('#cc-form').data('currency');
      UpgradePage.Form.token(cc_num, cc_exp, cc_cvc, amount, currency,
      UpgradePage.Form.pay)
      return false;
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
    console.log(error,result)
    $.ajax({
      url: '/user/settings/upgrade',
      type: 'POST',
      dataType: 'json',
      data: {token: result.token},
      success: UpgradePage.Form.success,
      error: UpgradePage.Form.error
    });
  },
  success: function(data) {
   $('.js-btn-pay').each(function(){ this.disabled = false; });
   $('.processing').hide();
   $('.message').hide();
   $('.btn-buy').hide();
   $('.cc-error').hide();
   $('.btn-download').removeClass('hidden');
   $('.btn-download').prop("href", data.url);
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
    submitHandler: UpgradePage.Form.submit,
    rules : {
      "cc-num" : { ccNumberValid : true,
        required: true
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
    showErrors: UpgradePage.Form.validationErrors
  });
}
}



}(jQuery, window.UpgradePage = window.UpgradePage || {}));
