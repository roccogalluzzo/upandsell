// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap/dist/js/bootstrap
//= require fullpage.js/jquery.fullPage
//= require products
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
        afterLoad: function(anchorLink, index){},
        afterRender: function(){},
        afterSlideLoad: function(anchorLink, index, slideAnchor, slideIndex){},
        onSlideLeave: function(anchorLink, index, slideIndex, direction){}
    });
});