// Product landing page related js
//= require jquery
//= require jquery_ujs
//= require excanvas.compiled.js
//= require canvg.js
//= require polyclip.js
//= require bootstrap/dist/js/bootstrap
//= require jquery.validation/jquery.validate.js
//= require jquery.payment/lib/jquery.payment.js
//= require product_page
$(document).ready(function() {

 ProductPage.init();

 $.getScript('https://bridge.paymill.com/');
});
