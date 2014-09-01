(function ($, Animations, undefined) {

  Animations.init = function() {
 // init controller
 var controller = new ScrollMagic();
Animations.Scenes.onLoading();
// assign handler "scene" and add it to Controller
var scene = new ScrollScene({duration: 100, triggerElement: '#checkout', offset: -315}).addTo(controller)
.on("start", Animations.Scenes.onCheckout);
scene.addIndicators();
};

Animations.Scenes = {
  onLoading: function(){
    var animate_btns = function() {
      $('.btn-more').show().addClass('animated fadeInUp');
      $('.btn-get-started').show().addClass('animated fadeInUp');
    };
    var animate_shadows = function(n) {
     $('.shadow-'+ n).show().addClass('animated fadeIn');
   };

   $('.btn-more').hide();
   $('.shadow-1').hide();
   $('.shadow-2').hide();
    $('#checkout h3').hide();
   $('#checkout p').hide();
   $('.btn-get-started').hide();
   $('.mock_iphone').hide();
   $('h1').addClass('animated fadeInUp');
   $('h2').addClass('animated fadeInUp');
   setTimeout(animate_btns, 500);
   setTimeout(function(){animate_shadows(2)}, 1100);
   setTimeout(function(){animate_shadows(1)}, 1600);

 },
   onCheckout: function(){

  $('#checkout p').show().addClass('animated fadeInUp');
   $('#checkout h3').show().addClass('animated fadeInUp');
      $('.mock_iphone').show().addClass('animated fadeInUp');
 },
}


}(jQuery, window.Animations = window.Animations || {}));