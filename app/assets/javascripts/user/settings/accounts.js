(function ($, Accounts, undefined) {

 Accounts.Edit = function() {
   $(".simple_form").validate({ showErrors: function(errorMap, errorList) {
    $.each(this.validElements(), function (index, element) {
      var $element = $(element);
      $element.data("title", "")
      .tooltip("destroy");
      $element.removeClass("has-error");
    });

    $.each(errorList, function (index, error) {
      var $element = $(error.element);
      $element.tooltip("destroy")
      .data("title", error.message)
      .data("placement", "bottom")
      .tooltip();
      $element.addClass("has-error");
    });

  }});
   $('#user_password').on('input',function(e){
     $('#password_confirmation').slideDown(300);
     $('#current_password').slideDown(300);
   // $('.fa-lock').removeClass('hidden');
 });


  initFilePreview();
 }


 function initFilePreview() {

  $("#js-preview-select").change(filePreviewAdd);
   if($("#local-preview-path").val()){
    loadPreview($("#local-preview-path").val());}

    if($("#preview").data('preview-url')){
      loadPreview($("#preview").data('preview-url'));
    }
  }

  function loadPreview(path){
    loadImage(path, function (img) {
      $('#preview').html(img);
      $('#js-preview-btn').text('Change');
    });
  }
  function filePreviewAdd(e, data){
   loadPreview(e.target.files[0]);
 }

}(jQuery, window.Accounts = window.Accounts || {}));