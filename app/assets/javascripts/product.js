// Product landing page related js
//= require jquery
//= require jquery_ujs
//= require bootstrap/dist/js/bootstrap
//= require jquery.validation/jquery.validate.js
//= require slimScroll/jquery.slimscroll
//= require custombox/src/jquery.custombox.js
//= require fullpage/jquery.fullPage
//= require jquery.payment/lib/jquery.payment.js
//= require pay_form
$(document).ready(function() {


    $('.btn').on('click', function ( e ) {
        $.fn.custombox( this, {
            width: 380,
            effect:         'slide',
            position: 'bottom',
            customClass:    'justme',
            speed:          600
        });
        PayForm.init();
        PayForm.paypalInit();
        e.preventDefault();
    });

    PayForm.paypalInit();



    $.getScript('https://bridge.paymill.com/');
});
