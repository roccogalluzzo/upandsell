
function hidePreviewBtn(){
 $("#btn-thumb-upload").fadeOut('slow');
 $('.preview').css("border", "none");
 $("#btn-thumb-upload").hover(function() {$("#btn-thumb-upload").fadeIn('fast');});
 $('.preview').hover(
   function() { $("#btn-thumb-upload").fadeIn('fast');},
   function() { $("#btn-thumb-upload").fadeOut('slow');}
);
}
function initProductForm(action){

        // Thumb code
        if(action == 'edit'){
          hidePreviewBtn();
        }
        $("#btn-thumb-upload").on('click', function(e){
         e.preventDefault();
         $(".input-thumb").trigger('click');
     });

        $('.input-thumb').change(function(e){
            //check estension
            var ext = $(this).val().split('.').pop().toLowerCase();
            if($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) {
                showAlert('error', 'invalid extension');
            }else{
                if ( e.target.files &&  e.target.files[0])
                 loadImage(
                  e.target.files[0],
                  function (img) {
                   if (img.type != 'error'){
                    $('.preview').html(img);
                }
            },{maxWidth: 215,
                maxHeight: 130,
                minWidth: 215,
                munHeight: 130
            } 
            );
         hidePreviewBtn();
         }
     });

// Javascript for product upload

function toggle_uploading(){
    $('.percent').toggle();
    $('#btn-product-cancel-upload').toggle();
}

function toggle_upload(){
   $('.product-upload-box > p').toggle();
   $('#btn-product-upload').toggle();
}

var upload;
$('.uploading').hide();
toggle_uploading();
if(action == 'edit'){

}

$('#btn-product-cancel-upload').click(function(e) {
    upload.abort();
    toggle_uploading();
    toggle_upload();
});


$('.input-file ').fileupload({
    dropZone: $('.product-upload-box')
})
//File Upload Events
.bind('fileuploadadd', function (e, data) {
   toggle_uploading();
   toggle_upload();
   $('#file_name').text(data.files[0].name);
  // $('.product-upload-box').fadeTo(100, 0.40);
})
.bind('fileuploaddone', function (e, data) { 
 //  $('.product-upload-box').fadeTo(100, 1);;
 toggle_uploading();
 toggle_upload();
 $('.product-upload-box > p').text(data.files[0].name);
 $('.product-upload-box > a > span').text('Change');
 $( "input[class=upload_id]" ).val(data.result.id);
 $( "input[class=upload_file_name]" ).val(data.files[0].name);
})
 //.bind('fileuploadfail', function (e, data) {/* ... */})
 //.bind('fileuploadalways', function (e, data) {/* ... */})
 .bind('fileuploadsubmit', function (e, data) { upload = data;})
 .bind('fileuploadprogress', function (e, data) {
    var progress = parseInt(data.loaded / data.total * 100, 10);
    $('#percentile').text(progress)
    
});


   // Prevent Default
   $("#btn-product-upload").on('click', function(e){
    e.preventDefault();
    $(".input-file").trigger('click');
});
        // Currency select code
        $(".dropdown-menu li a").click(function(){

            val = $(".btn-price > span").html();   
            $(".btn-price > span:first").html($(this).html());
            currency = $(this).children().first().data('currency');
            console.log(currency);
            $( "input[id=currency]" ).val(currency);
            $(this).html(val);
            $('.btn-group').removeClass('open');

            return false;
        });
        
// Disable drag and drop on all page
$(document).bind('drop dragover', function (e) { e.preventDefault();});
// Form Validation
initProductFormValidation();
}

function initProductFormValidation(){
    $( "#new_product").submit(function( event ) { 
        sub = true; 
        $( ".text-error").removeClass('text-error');

        if(!$( "input[class=upload_id]" ).val()){
            sub = false;
            showAlert('error', 'You must upload a file prior to create a product');
        }

        if(!$('#product_name').val()){
         $('#product_name_label').addClass('text-error');
         sub = false;
     }

     if((!$('#product_price').val()) || ($('#product_price').val() == '0.00')){
        $('#product_price_label').addClass('text-error');
        sub = false;
    }

    if(!$('.input-thumb').val()){
        $('#product_preview_label').addClass('text-error');
        sub = false;
    }

    if(!sub){
      event.preventDefault();
      return false;
  }
});

}

function showAlert(type, message){
 $('.alert-box')
 .html('<div class="alert alert-'+ type + '"><a class="close" data-dismiss="alert">×</a><span>'+message+'</span></div>');
}
