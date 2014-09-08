(function ($, Animations, undefined) {

  Animations.init = function() {

    $('.btn-more').on('click', function(){
      $('html,body').animate({scrollTop: $('#checkout').offset().top}, 900);
      return false;
    });
    Animations.reset();
    var controller = new ScrollMagic();
    Animations.Scenes.loading();

    var checkout_text = new ScrollScene({
      reverse: false,
      triggerElement: '#checkout',
      offset: -300})
    .addTo(controller)
    .on("start", Animations.Scenes.checkout);

    var checkout_image = new ScrollScene({
      reverse: false,
      triggerElement: '#checkout',
      offset: -30})
    .addTo(controller)
    .on("start", Animations.Scenes.checkoutImage);

    var payments_section = new ScrollScene({
      reverse: false,
      triggerElement: '#checkout',
      offset: 240})
    .addTo(controller)
    .on("start", Animations.Scenes.payments);

    var features_section = new ScrollScene({
      reverse: false,
      triggerElement: '.payments-section',
      offset: 230})
    .addTo(controller)
    .on("start", Animations.Scenes.features);

    var stats_section = new ScrollScene({
      reverse: false,
      triggerElement: '.features-section',
      offset: 570})
    .addTo(controller)
    .on("start", Animations.Scenes.stats);

    var pricing_section = new ScrollScene({
      reverse: false,
      triggerElement: '.teaser-section',
      offset: 355})
    .addTo(controller)
    .on("start", Animations.Scenes.pricing);

   // pricing_section.addIndicators();
   // checkout_text.addIndicators();
  //  stats_section.addIndicators();
  //  features_section.addIndicators();
  //  payments_section.addIndicators();
  //  checkout_image.addIndicators();

  };

  Animations.reset = function(){
   var hide_el = [
   '#checkout h3',
   '#checkout p',
   '.mock_iphone',
   '.mock-checkout',
   '.payments-section .section-illustration',
   '.payments-section .section-text',
   '.feature-box img',
   '.feature-box h5',
   '.feature-box p',
   '.ad-logo',
   '.plan-green',
   '.plan-blue'
   ];
   jQuery.each(hide_el, function(i, el){
    $(el).hide();
  });
 };

 Animations.Scenes = {
  loading: function(){

   $('.btn-more').removeClass('hidden-animation').addClass('animated fadeInUp');
   $('.btn-get-started').removeClass('hidden-animation').addClass('animated fadeInUp');
      $('.beta-input').removeClass('hidden-animation').addClass('animated fadeInUp');
        $('.beta-message').removeClass('hidden-animation').addClass('animated fadeInUp');
   setTimeout(function(){
     $('.browser-preview').removeClass('hidden').addClass('animated fadeInUp');
   },250);
   setTimeout(function(){$('.shadow-2').show().addClass('animated fadeIn');}, 1100);
   setTimeout(function(){$('.shadow-1').show().addClass('animated fadeIn');}, 1600);

 },
 checkout: function(){

  $('#checkout p').show().addClass('animated fadeInUp');
  $('#checkout h3').show().addClass('animated fadeInUp');
  $('.mock_iphone').show().addClass('animated fadeInUp');

},
checkoutImage: function(){

 $('.mock-checkout').show().addClass('animated fadeInUp');

},
payments: function(){

  $('.payments-section  .section-illustration').show().addClass('animated fadeInUp');
  $('.payments-section .section-text').show().addClass('animated fadeInUp');

},

features: function(){

  function show_box_icon(el) {
    $(el).find('img').show().addClass('animated fadeInLeft');
  };
  function show_box_text(el) {
    $(el).find('h5').show().addClass('animated fadeInLeft');
    $(el).find('p').show().addClass('animated fadeInLeft');
  };


  $('.feature-box').each(function(i, el){
    setTimeout(function(){show_box_icon(el);}, 400*(i));
  });
  setTimeout(function(){
    $('.feature-box').each(function(i, el){
      setTimeout(function(){show_box_text(el);}, 400*(i));
    });
  }, 1600);

},
stats: function(){

  function show_stat_icon(el) {
    $(el).show().addClass('animated fadeInUp');
  };
  $('.ad-logo').each(function(i, el){
    setTimeout(function(){show_stat_icon(el);}, 500*(i));
  });

},
pricing: function(){

  setTimeout(function(){
    $('.plan-green').show().addClass('animated fadeInUp');}, 500);
  setTimeout(function(){
    $('.plan-blue').show().addClass('animated fadeInUp');}, 1000);



}
}


}(jQuery, window.Animations = window.Animations || {}));