(function ($, Setup, undefined) {

 var settings = {};
 function init_settings() {
  settings = { form: $(".product")};
}

Setup.init = function() {
  $('.form-inline')
  .bind("ajax:success", function(evt, data, status, xhr){
   if(data.status == 200){
    $('#email').text($('#new-email').val());
    $('.form-inline').addClass('hidden');
  }

})
  $('#change-email').click( function() {
    $('.form-inline').removeClass('hidden');
  })
};

}(jQuery, window.Setup = window.Setup || {}));