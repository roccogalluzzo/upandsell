(function ($, Animations, undefined) {

  Animations.init = function() {
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
    $('.btn-get-started').hide();
    $('h1').addClass('animated fadeInUp');
    $('h2').addClass('animated fadeInUp');
    setTimeout(animate_btns, 500);
    setTimeout(function(){animate_shadows(2)}, 1100);
    setTimeout(function(){animate_shadows(1)}, 1600);

  };




}(jQuery, window.Animations = window.Animations || {}));