(function ($, Upload, undefined) {

  var el = {};
  var attrs = {file_key: null};

  Upload.init = function() {
   initElements();
   Upload.S3.init();
   Upload.Dropbox.init();
 }

 Upload.Dropbox = {
  init: function() {
    $('.btn-dropbox').on('click', Upload.Dropbox.chooser);
  },
  chooser: function() {
    Dropbox.choose({success: Upload.Dropbox.select, linkType: "direct"})
  },
  success: function(d) {
    ProductsTab.setCompleted('upload');
    $('#js-upload-text').text('Done');
    $('.step-upload-icon').removeClass().addClass('fa icon-cloud-upload step-upload-icon');

    if($('.upload-section').data('product-id')){
      fileChanged($('.upload-section').data('product-id'), d.file_key);
    }
    $("#file_key").val(d.file_key);
    el.form.find('input[type=submit]').removeAttr('disabled', 'disabled');
  },
  select: function(files){
    Upload.Animations.progressBar(100);
    ProductsTab.switchTo('product');
    $.ajax({
      url: '/user/products/files',
      type: 'POST',
      dataType: 'json',
      data: {file: files[0], provider: 'dropbox'},
      success: Upload.Dropbox.success
    });
  }
};

Upload.S3 = {
  init: function(){
    $(document).bind('dragover', Upload.S3.ondrag);
    $(document).bind('drop dragover', function (e) {
      e.preventDefault();
    });
    el.target.fileupload({
      autoUpload: true,
      type: 'POST',
      paramName: 'file',
      disableImageLoad: true,
      disableImageMetaDataLoad: true,
      dropZone: $('.drop-box'),
      dataType: 'xml'})
    .bind('fileuploadadd', Upload.S3.add)
    .bind('fileuploadprogress', Upload.S3.progress)
    .bind('fileuploaddone', Upload.S3.done)
    .bind('fileuploadfail', Upload.S3.fail);

    $('.file-change').on('click', fileChange);
  },
  signed_request: function(filename){
    $.ajax({
      url: '/user/products/files',
      type: 'POST',
      dataType: 'json',
      data: {name: filename, file_key:  $("#file_key").val()},
      async: false,
      success: function(d) { data = d; }
    });
    return data;
  },
  add: function(e, data){
    Upload.Animations.cancel_icon();
    Upload.Animations.progressBar(0);
    ProductsTab.switchTo('product');
    req = Upload.S3.signed_request(data.files[0].name);
    data.formData = req;
    attrs.file_key = req.key;
    var jqXHR = data.submit();
    Upload.S3.cancel(true, jqXHR);

  },
  progress: function(e, data){
    Upload.Animations.progressBar(parseInt(data.loaded / data.total * 100, 10));
  },
  done: function(e, data){
    ProductsTab.setCompleted('upload');
    $('#js-upload-text').text('Done');
    $('.step-upload-icon').removeClass().addClass('fa icon-cloud-upload step-upload-icon');
    if($('.upload-section').data('product-id')){
      fileChanged($('.upload-section').data('product-id'), attrs.file_key);
    }
    $("#file_key").val(attrs.file_key);
    el.form.find('input[type=submit]').removeAttr('disabled', 'disabled');
    Upload.S3.cancel(false);

  },
  cancel: function(action, istance) {
   if(action){
    $('#js-upload-tab').bind( 'click.abort',function(e)
    {
      istance.abort();
      Upload.Animations.error();
      Upload.S3.cancel(false);
      e.preventDefault();
    });
  }else{
    $('#js-upload-tab').unbind('click.abort');
  }
},
fail: function(e, data){
  console.log('fail');
  Upload.Animations.error();
  Upload.S3.cancel(false);
  ProductsTab.setDisabled('product');
  Upload.Animations.change();
  Upload.Animations.progressBar(0);
  $('.uploading-box').hide(400);
},
ondrag: function(e) {
  var dropZone = $('.drop-box'),
  timeout = window.dropZoneTimeout;
  if (!timeout) {
    dropZone.animate({height: 260, fontSize: 22});
    $('.upload-actions').fadeTo(200, 0.20);
  } else {
    clearTimeout(timeout);
  }
  var found = false,
  node = e.target;
  do {
    if (node === dropZone[0]) {
      found = true;
      break;
    }
    node = node.parentNode;
  } while (node != null);
  if (found) {
    dropZone.addClass('hover');
  } else {
    dropZone.removeClass('hover');
  }
  window.dropZoneTimeout = setTimeout(function () {
    window.dropZoneTimeout = null;
    dropZone.removeClass('in hover');
    dropZone.animate({height: 200, fontSize: 14});
    $('.upload-actions').fadeTo(200, 1);
  }, 100);
}
};

// Init Functions
function initElements() {
  el = {target: $("#js-s3-upload"),
  form: $(".product"),
  box: $(".upload-box"),
  uploading_box:  $('.uploading-box'),
  btn:   $('#product-upload-btn')};

  preview = {target: $(".input-thumb "),
  form: $(".product"),
  box: $(".upload-box-preview"),
  btn:   $('.btn-preview')};
}

// File related actions

function fileChanged(id, file_key) {
  $.ajax({
    url: "/user/products/" + id,
    type: 'POST',
    dataType: 'json',
    data: { _method: 'patch', product: {file_key: file_key}}
  });
  return data;
}

function fileChange() {
 Upload.Animations.change();
}

Upload.Gdrive = {
  init: function() {
    var picker = new FilePicker({
      apiKey: 'AIzaSyD23GgA6fxcG3g1oZILzAwzf1e1lKW_of4',
      clientId: '320319720032-hptnksdn2hm02635tnsh6qr017t535a1',
      buttonEl: document.getElementById('js-btn-drive'),
      onSelect: Upload.Gdrive.upload
    });
  },
  upload: function(file) {
    console.log(file);
    $.ajax({
      url: '/user/products/files',
      type: 'POST',
      dataType: 'json',
      data: {file: {name: file.originalFilename, url: file.downloadUrl}, provider: 'drive'},
      async: false,
      success: function(d) {
        data = d;
      }
    });
  }
};

// Animations
Upload.Animations = {


  change: function() {
    $('.upload-box').show(400);
    $('.uploading-box').slideDown(500);
    el.form.find('input[type=submit]').attr('disabled', 'disabled');
  },
  progressBar: function(percent) {
    $('#file-upload-progress').show().addClass('animated fadeIn');
    $('#js-upload-text').text('Uploading...');
    $('#file-upload-progress .progress-bar').css({width: percent +'%'});
  },
  error: function() {
    $('#file-upload-progress').hide();
    $('#js-upload-text').text('Upload product file');
    $('#file-upload-progress .progress-bar').css({width: '0%'})
    $('.step-upload-icon').removeClass().addClass('fa icon-cloud-upload step-upload-icon');
  },
  cancel_icon: function() {
    $('.step-upload-icon').removeClass().addClass('fa fa-times cancel-text step-upload-icon')
    $('#js-upload-text').text('Upload product file');

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
