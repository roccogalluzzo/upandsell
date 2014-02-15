(function ($, Product, undefined) {
 var settings = {
  uploadBtn: $("#product-upload-btn"),
  uploadPreviewBtn: $("#product-preview-upload")
};

Product.init = function() {
  s = settings;
  $("#currency").bind('click', function(e){

    syms = $("#currency").data('currency-symbols');
    vals = $("#currency").data('currency-values');
    i = $.inArray($(this).text(), syms);
    console.log(i, syms.length);
    if(i == (syms.length -1)){
      i =0;
    }else {
      i++;
    }
$("#currency").text(syms[i]);
$("#product_price_currency").val(vals[i]);
  });
    // setup upload product button
    $("#product-upload-btn").fileupload()
    .bind('fileuploadadd', function (e, data) {
     fileUploadAdd(data);})
    .bind('fileuploadprogress', function (e, data) {
      var percent= parseInt(data.loaded / data.total * 100, 10);
      updateProgressBar(percent);
    })
    .bind('fileuploaddone', function (e, data) {
      fileUploadDone(data);
    })
    .bind('fileuploadfail', function (e, data) {
     fileUploadFail(data);
   });
  };

  function fileUploadAdd(data){
    $('.progress').removeClass('invisible');
    $('.filename').text(data.files[0].name).removeClass('invisible');
    updateProgressBar(0);
    var jqXHR = data.submit();
    $('#product-upload-btn').bind( 'click.abort',function(e)
    {
      jqXHR.abort();
      e.preventDefault();
    });
    showBtn('cancel', 'danger');
  }
  function fileUploadDone(data){
   $('#product-upload-btn').unbind( 'click.abort');
   showBtn('change', 'primary');
 }
 function fileUploadFail(data){
  $('#product-upload-btn').unbind( 'click.abort');
  $('.filename').text('');
  showBtn('choose', 'primary');
  updateProgressBar(0);
}

function showBtn(text, type){
  $(".fileinput-button span").each(function() {
    if($(this).data('text-type') == text){
      $(this).removeClass('hidden');
    }else {
      $(this).addClass('hidden');
    }
    $('.fileinput-button')
    .removeClass('btn-primary')
    .removeClass('btn-danger')
    .addClass("btn-" + type);
  });
}

function updateProgressBar(percent){
  $('.progress .progress-bar').css({width: percent +'%'});
}

}(jQuery, window.Product = window.Product || {}));
