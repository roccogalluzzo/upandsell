// Product landing page related js
//= require jquery
//= require jquery_ujs
//= require bootstrap/dist/js/bootstrap
//= require fullpage.js/jquery.fullPage
$(document).ready(function() {
  $.fn.fullpage({
    verticalCentered: false,
    resize : false,
    anchors:['show', 'buy'],
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
          if(anchorLink == 'buy'){
            // call paypal
            $.ajax({
              url: '/products/paypal',
              type: 'GET',
              dataType: 'json',
              data: {product_id: $('.buy').data('product-id')},
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