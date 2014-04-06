(function ($, Upload, undefined) {
  var el = {};
  var attrs = {uuid: null, filename: null};
  function init_elements() {
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
  Upload.file = function() {
   init_elements();
 // setup upload product button
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

 if(!$("input[class=upload_uuid]" ).val()){
  //disable submit
  el.form.find('input[type=submit]').attr('disabled', 'disabled');
}
 $('.file-change').on('click', fileChange);
el.form.on("ajax:success", function(event, data, status, xhr) {
  console.log(data);
  if(data.product){
  $('.product-image').attr('src',data.product.preview);
  $('.product-name').text(data.product.name);
  $('.product-price').text(data.product.price_currency + ' ' +(data.product.price_cents/100));
  $('.slug').text(data.product.slug);
  $('.btn-social-twitter').on('click', function(){
      window.open(data.product.twitter_url, 'tweet','toolbar=0,status=0,width=600,height=305')
  });
  $('.btn-social-facebook').on('click', function(){
      window.open(data.product.facebook_url, 'share','toolbar=0,status=0,width=600,height=305')
  });
$('.share').show(400);
  Upload.Animations.product_added();
}
});
$('.edit-product').on('click', function(){
 Upload.Animations.product_edit();
});
}

Upload.filePreview = function() {
 init_elements();

 preview.target.change(filePreviewAdd);

 if($("#local-preview-path").val()){
  loadPreview($("#local-preview-path").val());
}
if($("#preview").data('preview-url')){
  loadPreview($("#preview").data('preview-url'));
}
}
function loadPreview(path){
  loadImage(path, function (img) {
    $('#preview').html(img);
  });
}
function filePreviewAdd(e, data){
 loadPreview(e.target.files[0]);
}
// private functions
function fileSignedRequest(filename) {
  $.ajax({
    url: '/user/products/upload_request',
    type: 'GET',
    dataType: 'json',
    data: {name: filename, uuid:  el.form.find( "input[class=upload_uuid]" ).val()},
    async: false,
    success: function(d) { data = d; }
  });
  return data;
}
function fileChanged(id, filename, new_uuid) {
  $.ajax({
    url: '/user/products/file_changed',
    type: 'POST',
    dataType: 'json',
    data: {id: id, new_uuid:  new_uuid, filename: filename}
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
  data.formData = req.fields;
  attrs.uuid = req.id;
  attrs.filename = req.filename;
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
fileChanged($('.upload-section').data('product-id'), attrs.filename, attrs.uuid);
  }
  el.form.find( "input[class=upload_uuid]" ).val(attrs.uuid);
  el.form.find( "input[class=filename]" ).val(attrs.filename);
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
}(jQuery, window.Product.Upload = window.Upload || {}));
