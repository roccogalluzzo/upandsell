(function ($, Upload, undefined) {
  var el = {};
  var attrs = {uuid: null, filename: null};
  function init_elements() {
    el = {target: $(".direct-upload"),
    form: $(".simple_form"),
    box: $(".upload-box"),
    btn:   $('#product-upload-btn')};
  }
  Upload.file = function() {
   init_elements();

 // setup upload product button
 el.target.fileupload({
  autoUpload: true,
  type: 'POST',
  paramName: 'file',
  dataType: 'xml'})
 .bind('fileuploadadd', fileAdd)
 .bind('fileuploadprogress', fileProgress)
 .bind('fileuploaddone', fileDone)
 .bind('fileuploadfail', fileFail);
}

// private functions
function fileSignedRequest(filename) {
  $.ajax({
    url: '/customer/products/upload_request',
    type: 'GET',
    dataType: 'json',
    data: {name: filename},
    async: false,
    success: function(d) { data = d; }
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
  Upload.Animations.boxToLeft();
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
}

function fileDone(e, data) {
  el.form.find( "input[class=upload_uuid]" ).val(attrs.file_uuid);
  el.form.find( "input[class=filename]" ).val(attrs.filename);
  Upload.Animations.done();
  bindCancel(false);
  Upload.Animations.actionBtn('change');
  //fileError('hide');
}

function fileFail(e, data) {
  bindCancel(false);
  Upload.Animations.done();
  Upload.Animations.actionBtn('choose');
  Upload.Animations.progressBar(0);
}
function fileProgress(e, data) {
  Upload.Animations.progressBar(parseInt(data.loaded / data.total * 100, 10));
}

// Animations
Upload.Animations = {
  boxToLeft: function() {
    el.form.animate({ opacity: '1'}, 1000);
    el.box.animate({left: '0', top: '0'}, 1000);
    el.box.find('.fa').animate({ opacity: '0.20'}, 1000);
    el.box.find('.upload-box-inner').animate({ opacity: '0.4'}, 1000);
  },
  boxToCenter: function() {
   el.box.find('.filename').css('opacity', 0);
   el.form.animate({ opacity: '0.20'}, 1000);
   el.box.animate({left: '178%', top: '15%'}, 1000);
   el.box.find('.progress').css('opacity', 0);
   el.box.find('.upload-box-inner').animate({ opacity: '1'}, 1000);
 },
 start: function() {
  el.box.find('.progress').animate({ opacity: '0.8'}, 1000);
  el.box.find('.filename').css('opacity', 0.9);
},
done: function() {
 el.box.find('.progress').animate({ opacity: '0'}, 1000, '', function(){
   el.box.find('.upload-box-inner').animate({ opacity: '0.6'}, 1000);
 });
},
progressBar: function(percent) {
  el.box.find('.progress .progress-bar').css({width: percent +'%'});
},
actionBtn: function(action) {
 btns = {cancel: 'btn-danger', choose: 'btn-primary',
 change: 'btn-primary'}
 el.box.find(".fileinput-button span").each(function() {
  if($(this).data('text-type') == action){
    $(this).removeClass('hidden');
  }else {
    $(this).addClass('hidden');
  }
  $('.fileinput-button')
  .removeClass('btn-primary')
  .removeClass('btn-danger')
  .addClass(btns[action]);
});
},
fileStatus: function(filename, status) {
  switch(status){
   case 'visible':
   el.box.find('.filename').text(filename).removeClass('invisible');
   break;
   case 'error':
//TODO error case
break;
}
}
}
}(jQuery, window.Product.Upload = window.Upload || {}));