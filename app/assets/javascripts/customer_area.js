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
//= require turbolinks
//= require bootstrap/dist/js/bootstrap
//= require jquery-file-upload//js/vendor/jquery.ui.widget.js
//= require jquery-file-upload//js/jquery.iframe-transport.js
//= require blueimp-load-image/js/load-image
//= require jquery-file-upload//js/jquery.fileupload.js
//= require jquery-file-upload/js/jquery.iframe-transport.js
//= require jquery-file-upload/js/jquery.fileupload-process.js
//= require jquery.validation/jquery.validate.js
//= require product

$(document).ready(function(){

 $( "#new-product" ).on('shown.bs.modal', function(){

  Product.init();

  $("form").validate({
    debug: true,
    errorClass: "has-error",
    errorPlacement: function(error,element) {
      return true;
    },
    highlight: function(element, errorClass, validClass) {
      $(element).parent().addClass(errorClass).removeClass(validClass);
    },
    unhighlight: function(element, errorClass, validClass) {
      $(element).parent().removeClass(errorClass).addClass(validClass);
    },
    rules: {
      product_price: {
        min: 1
      }
    },
    onfocusout: false,

  });
});
});

