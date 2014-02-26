// Product landing page related js
//= require jquery
//= require jquery_ujs
//= require bootstrap/dist/js/bootstrap
//= require fullpage.js/jquery.fullPage
//= require jquery.payment/lib/jquery.payment.js
//= require pay_form
$(document).ready(function() {
  PayForm.init();
  $.fn.fullpage({
    verticalCentered: false,
    resize : false,
    anchors:['show', 'buy', 'buy-paypal'],
    scrollingSpeed: 700,
    easing: null,
    menu: false,
    navigation: false,
    navigationPosition: 'right',
    slidesNavigation: true,
    slidesNavPosition: 'bottom',
    autoScrolling: true,
    scrollOverflow: false,
    css3: false,
    paddingTop: '50px',
    paddingBottom: '0',
    keyboardScrolling: false,
    touchSensitivity: 15,
    continuousVertical: false,
    animateAnchor: true,
    normalScrollElements: window,

        //events
        onLeave: function(index, direction){},
        afterLoad: function(anchorLink, index){
          if(anchorLink == 'buy-paypal'){
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
        afterSlideLoad: function(anchorLink, index, slideAnchor, slideIndex){},
        onSlideLeave: function(anchorLink, index, slideIndex, direction){}
      });
});