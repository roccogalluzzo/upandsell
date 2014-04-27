// Product landing page related js
//= require jquery
//= require jquery_ujs
//= require bootstrap/dist/js/bootstrap
//= require jquery.validation/jquery.validate.js
//= require slimScroll/jquery.slimscroll
//= require custombox/src/jquery.custombox.js
//= require jquery.payment/lib/jquery.payment.js
//= require jquery.transit/jquery.transit
//= require product_page
$(document).ready(function() {

 ProductPage.init();

 $.getScript('https://bridge.paymill.com/');
});
