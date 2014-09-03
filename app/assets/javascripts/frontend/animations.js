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

var features_section = new ScrollScene({
  reverse: false,
  triggerElement: '.payments-section',
  offset: 230}).addTo(controller).on("start", Animations.Scenes.onFeatures);
features_section.addIndicators();

var stats_section = new ScrollScene({
  reverse: false,
  triggerElement: '.features-section',
  offset: 570}).addTo(controller).on("start", Animations.Scenes.onStats);
stats_section.addIndicators();


var pricing_section = new ScrollScene({
  reverse: false,
  triggerElement: '.teaser-section',
  offset: 355}).addTo(controller).on("start", Animations.Scenes.onPricing);

pricing_section.addIndicators();
};

Animations.Scenes = {
  onLoading: function(){
    var animate_btns = function() {
      $('.btn-more').removeClass('hidden-animation').addClass('animated fadeInUp');
      $('.btn-get-started').removeClass('hidden-animation').addClass('animated fadeInUp');
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
$('.small-cloud-left-t').addClass('animate-cloud-left');
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

onFeatures: function(){
  function show_box_icon(el) {
    $(el).find('img').removeClass('hidden-animation').addClass('animated fadeInLeft');
  };
  function show_box_text(el) {

    $(el).find('h5').removeClass('hidden-animation').addClass('animated fadeInLeft');
    $(el).find('p').removeClass('hidden-animation').addClass('animated fadeInLeft');

  };


  $('.feature-box').each(function(i, el){
    setTimeout(function(){show_box_icon(el);}, 500*(i));
  });
  setTimeout(function(){
    $('.feature-box').each(function(i, el){
      setTimeout(function(){show_box_text(el);}, 500*(i));
    });
  }, 1800);

},
onStats: function(){
  function show_stat_icon(el) {
    $(el).removeClass('hidden-animation').addClass('animated fadeInUp');
  };



  $('.ad-logo').each(function(i, el){
    setTimeout(function(){show_stat_icon(el);}, 500*(i));
  });


},
onPricing: function(){
  function show_stat_icon(el) {

  };




    setTimeout(function(){
      $('.plan-green').removeClass('hidden-animation').addClass('animated fadeInUp');}, 500);
     setTimeout(function(){
      $('.plan-blue').removeClass('hidden-animation').addClass('animated fadeInUp');}, 1000);



}
}


}(jQuery, window.Animations = window.Animations || {}));