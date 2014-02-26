(function ($, PayForm, undefined) {


  PayForm.init = function() {
    $('input.cc-num').payment('formatCardNumber');
    $('input.cc-exp').payment('formatCardExpiry');
    $('input.cc-cvc').payment('formatCardCVC');
    $('form.cc-form').submit(submit);
  }

  function submit() {
    cc_num = $('input.cc-num').val().replace(/\s+/g, '');
    cc_exp = $('input.cc-exp').payment('cardExpiryVal')
    cc_cvc = $('input.cc-cvc').val();
    product = getProductInfo($('.buy').data('product-id'));
    console.log(product.price);
    getToken(cc_num, cc_exp, cc_cvc, product.price, product.currency, pay)
    event.preventDefault();
  }


  function pay(error, result) {
    console.log(error, result)
    $.ajax({
      url: '/products/pay',
      type: 'POST',
      dataType: 'json',
      data: {product_id: $('.buy').data('product-id'),
       token: result.token,
       email: $('input.cc-email').val()},
      success: function(d) { //todo
      }
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