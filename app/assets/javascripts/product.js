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
    var file_uuid = null;
    // setup upload product button
    $(".direct-upload").fileupload({
      autoUpload: true,
      type: 'POST',
      paramName: 'file',
      dataType: 'xml'}
      )
    .bind('fileuploadadd', function (e, data) {
      $('.progress').removeClass('invisible');
      $('.filename').text(data.files[0].name).removeClass('invisible');
      updateProgressBar(0);
      $.ajax({
        url: '/customer/products/upload_request',
        type: 'GET',
        dataType: 'json',
        data: {name: data.files[0].name},
        async: false,
        success: function(d) {
          data.formData = d.fields;
          window.file_uuid = d.id;
          window.filename = d.filename;


          var jqXHR = data.submit();
          $('#product-upload-btn').bind( 'click.abort',function(e)
          {
            jqXHR.abort();
            e.preventDefault();
          });

        }
      });

      showBtn('cancel', 'danger');
    })
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

  }
  function fileUploadDone(data){
    $( "input[class=upload_uuid]" ).val(window.file_uuid);
    $( "input[class=filename]" ).val(window.filename);

    $('#product-upload-btn').unbind( 'click.abort');
    showBtn('change', 'primary');
    fileError('hide');
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

function fileError(action){
  if(action == 'hide'){
    $('.file-error').addClass('hidden');
    $('.file-row-error').removeClass('file-row-error');
  }else {
    $('.file-error').removeClass('hidden');
    $('.file-row-error').addClass('file-row-error');
  }
}
  function updateProgressBar(percent){
    $('.progress .progress-bar').css({width: percent +'%'});
  }

}(jQuery, window.Product = window.Product || {}));
