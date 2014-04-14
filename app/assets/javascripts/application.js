//
//  Backend javascript manifest
//
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require bootstrap/dist/js/bootstrap
//= require jquery-file-upload//js/vendor/jquery.ui.widget.js
//= require jquery-file-upload//js/jquery.iframe-transport.js
//= require blueimp-load-image/js/load-image.min.js
//= require jquery-file-upload//js/jquery.fileupload.js
//= require jquery-file-upload/js/jquery.iframe-transport.js
//= require jquery-file-upload/js/jquery.fileupload-process.js
//= require jquery-file-upload/js/jquery.fileupload-image.js
//= require jquery.validation/jquery.validate.js
//= require flat-ui-pro/js/bootstrap-switch.js
//= require flat-ui-pro/js/bootstrap-select.js
//= require momentjs/min/moment.min.js
//= require user/product
//= require raphael/raphael
//= require morris.js/morris
//= require user/product/upload
//= require user/stats
//= require user/setup

$(document).ready(function(){

  if ($(".graph").text().length > 1) {
 // SummaryChart("dashboard_chart", $('.graph').data('earnings'));
  Stats.init();
}

if ($(".alert").text().length > 20) {
  $(".alert").fadeIn(1000, function() { $(this).delay(4000).fadeOut("slow"); });
}

 $("select").selectpicker({style: 'btn btn-primary', menuStyle: 'dropdown-inverse'});
 $(".select").removeClass('form-control');

$("[data-toggle='switch']").wrap('<div class="switch" />').parent().bootstrapSwitch();
$("[data-toggle='switch']").change( function(){
   $.ajax({
    url: '/user/settings/update_payments',
    type: 'POST',
    dataType: 'json',
    data: {type: $(this).data('type'), value:  $(this).prop('checked')}
    });
});

Product.init();
Setup.init();

});
