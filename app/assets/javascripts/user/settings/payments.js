(function ($, Payments, undefined) {

 Payments.Edit = function() {
  $('.select-gateway').on('change', function(e){
    console.log($(this).val())
    if($(this).val() == 'Braintree'){
      $('#js-braintree-inputs').fadeIn().removeClass('hidden');
    }else {
 $('#js-braintree-inputs').fadeOut().addClass('hidden');
    }
  });
  $("[data-toggle='switch']").on('switchChange.bootstrapSwitch', function(event, state) {
    if( $(this).data('type') == 'paypal'){
      $('.paypal-box').toggleClass('unfocus')
    }
    if( $(this).data('type') == 'cc'){
      $('.cc-form-box').toggleClass('unfocus')
    }
  });
}
}(jQuery, window.Payments = window.Payments || {}));