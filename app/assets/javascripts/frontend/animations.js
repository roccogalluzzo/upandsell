(function ($, Animations, undefined) {

  Animations.init = function() {
 // init controller

 var controller = new ScrollMagic();


 Animations.Scenes.onLoading();

// assign handler "scene" and add it to Controller
var checkout_text = new ScrollScene({
  reverse: false,
  triggerElement: '#checkout',
  offset: -300}).addTo(controller)
.on("start", Animations.Scenes.onCheckout);
checkout_text.addIndicators();

var checkout_image = new ScrollScene({
  reverse: false,
  triggerElement: '#checkout',
  offset: -30}).addTo(controller)
.on("start", Animations.Scenes.onCheckoutImage);

checkout_image.addIndicators();


var payments_section = new ScrollScene({
  reverse: false,
  triggerElement: '#checkout',
  offset: 240}).addTo(controller).on("start", Animations.Scenes.onPayments);

payments_section.addIndicators();

};


Animations.Scenes = {
  onLoading: function(){


    var animate_btns = function() {
      $('.btn-more').removeClass('hidden-md hidden-lg').addClass('animated fadeInUp');
      $('.btn-get-started').removeClass('hidden-md hidden-lg').addClass('animated fadeInUp');
    };
    var animate_shadows = function(n) {
     $('.shadow-'+ n).show().addClass('animated fadeIn');
   };
   animate_btns();
     setTimeout(function(){
   $('.browser-preview').removeClass('hidden').addClass('animated fadeInUp');
}, 250);
   setTimeout(function(){animate_shadows(2)}, 1100);
   setTimeout(function(){animate_shadows(1)}, 1600);

 },
 onCheckout: function(){
  $('#checkout p').show().addClass('animated fadeInUp');
  $('#checkout h3').show().addClass('animated fadeInUp');
  $('.mock_iphone').show().addClass('animated fadeInUp');
},
onCheckoutImage: function(){
 $('.mock-checkout').show().addClass('animated fadeInUp');
},
onPayments: function(){
  $('.payments-section  .section-illustration').show().addClass('animated fadeInUp');
  $('.payments-section .section-text').show().addClass('animated fadeInUp');
},

}


}(jQuery, window.Animations = window.Animations || {}));