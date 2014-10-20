(function ($, Payments, undefined) {

 Payments.Edit = function() {
  console.log('ff')
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