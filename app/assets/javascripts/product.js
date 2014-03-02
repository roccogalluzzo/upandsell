// Product landing page related js
//= require jquery
//= require jquery_ujs
//= require bootstrap/dist/js/bootstrap
//= require jquery.validation/jquery.validate.js
//= require slimScroll/jquery.slimscroll
//= require fullpage/jquery.fullPage
//= require jquery.payment/lib/jquery.payment.js
//= require pay_form
var PAYMILL_PUBLIC_KEY = '98121246257b75d119a343538348e8bf';
$(document).ready(function() {
  PayForm.init();
  $.fn.fullpage({
    verticalCentered: false,
    resize : false,
    anchors:['show', 'buy', 'download'],
    scrollingSpeed: 350,
    easing: null,
    menu: false,
    navigation: false,
    navigationPosition: 'right',
    slidesNavigation: false,
    autoScrolling: true,
    scrollOverflow: true,
    css3: false,
    paddingTop: '50px',
    paddingBottom: '0',
    keyboardScrolling: false,
    touchSensitivity: 15,
    continuousVertical: false,
    animateAnchor: false,
    normalScrollElements: window,

        //events
        onLeave: function(index, direction){},
        afterSlideLoad: function(anchorLink, index, slideAnchor, slideIndex){
          console.log(slideIndex)
          if(slideIndex== 1){
            // call paypal
            $.ajax({
              url: '/products/paypal',
              type: 'GET',
              dataType: 'json',
              data: {product_id: $('.buy-paypal').data('product-id')},
              async: false,
              success: function(d) { window.location.replace(d.url) }
            });
          }
        },
        afterRender: function(){},
        onSlideLeave: function(anchorLink, index, slideIndex, direction){}
      });

$.getScript('https://bridge.paymill.com/');
});
