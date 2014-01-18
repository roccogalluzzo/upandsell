$(document).ready(function(){

  $('#btn-buy')
  .bind("ajax:success", function(evt, data, status, xhr){

    var url = "https://www.sandbox.paypal.com/webapps/adaptivepayment/flow/pay?expType=light&payKey=" + data.pay_key
    var paypal_flow= new PAYPAL.apps.DGFlow({expType: 'light'});
    paypal_flow.startFlow(url);
  })

});
