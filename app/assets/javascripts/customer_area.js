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
//= require jquery-file-upload//js/vendor/jquery.ui.widget.js
//= require jquery-file-upload//js/jquery.iframe-transport.js
//= require blueimp-load-image/js/load-image.min.js
//= require jquery-file-upload//js/jquery.fileupload.js
//= require jquery-file-upload/js/jquery.iframe-transport.js
//= require jquery-file-upload/js/jquery.fileupload-process.js
//= require jquery-file-upload/js/jquery.fileupload-image.js
//= require jquery.validation/jquery.validate.js
//= require flat-ui-official/js/bootstrap-switch.js
//= require d3/d3.js
//= require nvd3/nv.d3.js
//= require user/product
//= require user/product/upload
//= require user/nv-model
//= require user/graph

$(document).ready(function(){
  SummaryChart("dashboard_chart", $('.graph').data('earnings'));
  if ($(".alert").text().length > 20) {
$(".alert").fadeIn(1000, function() { $(this).delay(4000).fadeOut("slow"); });
}
  $('.stats-range').click(function(){

    $.ajax({
    url: '/user/products/metrics',
    type: 'GET',
    dataType: 'json',
    data: {type: 'earnings', range: $(this).data('range')},
    async: false,
    success: function(d) {
      console.log(d);
      redrawSummaryChart("dashboard_chart", d) }
  });
  });
  $("[data-toggle='switch']").wrap('<div class="switch" />').parent().bootstrapSwitch();
  Product.init();
  $('.list-item').click(function(){
    location.href = $(this).data('url')
  })
  .hover(function(){
    $(this).find('.fa-link').toggleClass('hidden');
  },
  function(){
   $(this).find('.fa-link').toggleClass('hidden');
 }
 );

});

