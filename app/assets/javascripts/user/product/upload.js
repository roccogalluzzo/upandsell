(function ($, Upload, undefined) {

  var el = {};
  var attrs = {file_key: null};

  Upload.init = function() {
   initElements();
   initFileUpload();
   initForm();
   initFilePreview();
 }

// Init Functions

function initElements() {
  el = {target: $(".direct-upload"),
  form: $(".product"),
  box: $(".upload-box"),
  uploading_box:  $('.uploading-box'),
  btn:   $('#product-upload-btn')};

  preview = {target: $(".input-thumb "),
  form: $(".product"),
  box: $(".upload-box-preview"),
  btn:   $('.btn-preview')};
}

function initFileUpload() {
 el.target.fileupload({
  autoUpload: true,
  type: 'POST',
  paramName: 'file',
  disableImageLoad: true,
  disableImageMetaDataLoad: true,
  dropZone: el.box,
  dataType: 'xml'})
 .bind('fileuploadadd', fileAdd)
 .bind('fileuploadprogress', fileProgress)
 .bind('fileuploaddone', fileDone)
 .bind('fileuploadfail', fileFail);

 $('.file-change').on('click', fileChange);
}

function initForm() {
 if(!$("input[class=file_key]" ).val()){
  el.form.find('input[type=submit]').attr('disabled', 'disabled');}

  el.form.on("ajax:success", productSave);

  $('.toggle-published').on("ajax:beforeSend", function(event, data, status, xhr){
    $(this).attr('disabled', 'disabled').text($(this).data('with'));
  })
  .on("ajax:success", function(event, data, status, xhr){
    $(this).removeAttr("disabled").text(data.action).data('with', data.with);
  });

  $('.edit-product').on('click', Upload.Animations.product_edit);
}

function initFilePreview() {

  preview.target.change(filePreviewAdd);
  if($("#local-preview-path").val()){
    loadPreview($("#local-preview-path").val());}

    if($("#preview").data('preview-url')){
      loadPreview($("#preview").data('preview-url'));
    }
  }

// Form Related Actions

function productSave(event, data, status, xhr) {

  if(data.product){
    $('.product-image').attr('src',data.product.preview.thumb);
    $('.product-name').text(data.product.name);
    $('.product-price').text(data.product.currency + ' ' +(data.product.price/100));
    if(data.status == 200){
      el.form.attr('action', data.product.edit_url);
      $('<input>').attr({
        type: 'hidden',
        value: 'patch',
        name: '_method'
      }).appendTo(el.form);

      $('#js-slug').text(data.product.slug);
      $("#js-ext-link").attr('href', data.product.slug);
      $('.btn-social-twitter').on('click', function(){
        window.open(data.product.twitter_url, 'tweet','toolbar=0,status=0,width=600,height=305')
      });
      $('.btn-social-facebook').on('click', function(){
        window.open(data.product.facebook_url, 'share','toolbar=0,status=0,width=600,height=305')
      });
      $('.share').show(400);
    }
    Upload.Animations.product_added();
  }
}


// FilePreview reletad actions

function loadPreview(path){
  loadImage(path, function (img) {
    $('#preview').html(img);
  });
}
function filePreviewAdd(e, data){
 loadPreview(e.target.files[0]);
}

// File related actions

function fileSignedRequest(filename) {
  $.ajax({
    url: '/user/products/files',
    type: 'POST',
    dataType: 'json',
    data: {name: filename, file_key:  el.form.find( "input[class=file_key]" ).val()},
    async: false,
    success: function(d) { data = d; }
  });
  return data;
}
function fileChanged(id, file_key) {
  $.ajax({
    url: '/user/products/file_changed',
    type: 'POST',
    dataType: 'json',
    data: {id: id, file_key: file_key}
  });
  return data;
}
function bindCancel(action, istance){
 if(action){
  el.btn.bind( 'click.abort',function(e)
  {
    istance.abort();
    e.preventDefault();
  });
}else{
  el.btn.unbind( 'click.abort');
}
}
function fileAdd(e, data){
  Upload.Animations.start();
  Upload.Animations.fileStatus(data.files[0].name, 'visible');
  Upload.Animations.progressBar(0);
  req = fileSignedRequest(data.files[0].name);
  // set data request to form
  data.formData = req;
  attrs.file_key = req.key;
  var jqXHR = data.submit();
  bindCancel(true, jqXHR);
  Upload.Animations.actionBtn('cancel');
   // after initial file upload drop zone must be only on upload box
 // not works el.file_upload.dropZone = el.box;
}
function fileChange() {
 Upload.Animations.change();
}

function fileDone(e, data) {
  if($('.upload-section').data('product-id')){
    fileChanged($('.upload-section').data('product-id'), attrs.file_key);
  }
  el.form.find( "input[class=file_key]" ).val(attrs.file_key);
  Upload.Animations.done();
  bindCancel(false);
  Upload.Animations.actionBtn('change');
  //fileError('hide');
  $('.fileinput-button').on('click', fileChange);
}

function fileFail(e, data) {
  bindCancel(false);
  Upload.Animations.change();
  Upload.Animations.progressBar(0);
}
function fileProgress(e, data) {
  Upload.Animations.progressBar(parseInt(data.loaded / data.total * 100, 10));
}

// Animations
Upload.Animations = {
  product_added: function() {
    $('.product_form').slideUp(500);
    $('.product_show').show(400);
  },
  product_edit: function() {
    $('.product_form').show(500);
    $('.product_show').slideUp(400);
  },
  start: function() {
    $('.upload-box').slideUp(500);
    $('.uploading-box').show(400);
    el.form.find('input[type=submit]').attr('disabled', 'disabled');
  },
  change: function() {
    $('.upload-box').show(400);
    $('.uploading-box').slideDown(500);
    el.form.find('input[type=submit]').attr('disabled', 'disabled');
  },
  done: function() {
   el.uploading_box.find('.progress').animate({ opacity: '0'}, 1000, '', function(){
     el.form.find('input[type=submit]').removeAttr('disabled', 'disabled');
     el.uploading_box.find('.progress .progress-bar').css({width: '0%'});
   });
 },
 progressBar: function(percent) {
  el.uploading_box.find('.progress').show().animate({ opacity: '1'}, 100)
  el.uploading_box.find('.progress .progress-bar').css({width: percent +'%'});
},
actionBtn: function(action) {
 btns = {cancel: 'btn-danger', change: 'btn-primary'};
 btns_text = {cancel: 'Cancel', change: 'Change'};
 $('.fileinput-button')
 .removeClass('btn-primary')
 .removeClass('btn-danger')
 .addClass(btns[action]).text(btns_text[action]);
},
fileStatus: function(filename, status) {
  switch(status){
   case 'visible':
   el.uploading_box.find('.filename').text(filename).removeClass('invisible');
   break;
   case 'error':
//TODO error case
break;
}
}
}
}(jQuery, window.Upload = window.Upload || {}));
