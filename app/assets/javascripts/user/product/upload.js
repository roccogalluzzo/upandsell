(function ($, Upload, undefined) {

  var el = {};
  var attrs = {file_key: null};

  Upload.init = function() {
    Upload.init_elements();
    Upload.S3.init();
    Upload.Dropbox.init();
  }

  Upload.init_elements = function() {
    el = {form: $(".product"),
    box: $(".upload-box"),
    uploading_box:  $('.uploading-box'),
  };

  preview = {target: $(".input-thumb "),
  form: $(".product"),
  box: $(".upload-box-preview"),
  btn:   $('.btn-preview')};
}

Upload.Dropbox = {
  init: function() {
    $('.btn-dropbox').on('click', Upload.Dropbox.chooser);
  },
  chooser: function() {
    Dropbox.choose({success: Upload.Dropbox.select, linkType: "direct"});
  },
  success: function(d) {
    Upload.Animations.complete(d.file_key);
    $('.btn-dropbox span').text('Dropbox');
    $('.btn-dropbox').toggleClass('dropbox-disabled');
  },
  simulate_progress: function() {
    $('.progress .progress-bar').animate({width: '100%'}, 1000);
  },
  select: function(files){
    Upload.Animations.start(files[0]);
    Upload.Dropbox.simulate_progress();
    $('.btn-dropbox span').text('Uploading...');
    $('.btn-dropbox').toggleClass('dropbox-disabled');
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
    $('.js-s3-upload').fileupload({
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
    Upload.Animations.start(data.files[0]);
    $('.btn-cancel').show();
    $('.btn-computer').hide();
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
    Upload.Animations.complete(attrs.file_key);
    Upload.S3.cancel(false);
    $('.btn-cancel').hide();
    $('.btn-computer').show();
  },
  cancel: function(action, istance) {
   if(action){
    $('.btn-cancel').bind( 'click.abort',function(e)
    {
      istance.abort();
      Upload.Animations.error();
      Upload.S3.cancel(false);
      $('.btn-cancel').hide();
      $('.btn-computer').show();
      e.preventDefault();
    });
  }else{
    $('.btn-cancel').unbind('click.abort');
  }
},
fail: function(e, data){
  Upload.Animations.error();
  Upload.S3.cancel(false);
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

  start: function(file) {
    Upload.Animations.progressBar(0);
    $('.progress').show().removeClass('animated fadeOut').addClass('animated fadeIn');
    if($('.upload').hasClass('active')){
      ProductsTab.switchTo('product');
    }
    $('.js-filename').text(file.name);
    $('.btn-dropbox').fadeTo(100, 0.2);
    $('.btn-computer').fadeTo(100, 0.2);
  },
  complete: function(file_key) {
    if(window.EDIT_PRODUCT){
      Products.Form.update_product_file(file_key);
    }
    $('.progress').addClass('animated fadeOut');
    $('.btn-dropbox').fadeTo(100, 1);
    $('.btn-computer').fadeTo(100, 1);
    if($('.upload')){
      ProductsTab.setCompleted('upload');
    }
    console.log(file_key);
    $("#file_key").val(file_key);
    el.form.find('input[type=submit]').removeAttr('disabled', 'disabled');

  },
  change: function() {
    $('.upload-box').show(400);
    $('.uploading-box').slideDown(500);
    el.form.find('input[type=submit]').attr('disabled', 'disabled');
  },
  progressBar: function(percent) {
    $('.progress .progress-bar').css({width: percent +'%'});
  },
  error: function() {
    $('.progress').hide();
    $('.progress .progress-bar').css({width: '0%'});
    $('.btn-dropbox').fadeTo(100, 1);
    $('.btn-computer').fadeTo(100, 1);
    $('.js-filename').text('');
    Up.alert.open("Error: Product File Not Uploaded.");
  },

}

}(jQuery, window.Upload = window.Upload || {}));
