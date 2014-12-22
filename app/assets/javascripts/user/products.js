(function ($, Products, undefined) {

 var settings = {};
 function init_settings() {
  settings = { form: $(".product")};
}
Products.Index = function() {
  Products.init();
  ProductsList.init();
};

Products.New = function() {
  window.EDIT_PRODUCT = false;
  window.EDIT_PRODUCT_FILE = false;
  Products.init();
  Products.Form.init();
};

Products.Edit = function() {
  window.EDIT_PRODUCT = true;
  Products.init();
  Products.Form.init();
  $('.product-form-preview').css('border-radius', '6px 6px 6px 0');
  $('#preview').css('border-radius', '6px 6px 0px 0');
};

Products.init = function() {
  init_settings();
  copyToClipboard($("#js-copy-to-clipboard"));
};

function copyToClipboard(element) {
  ZeroClipboard.config( { moviePath: 'ZeroClipboard.swf' } );
  var client = new ZeroClipboard(element);
  client.on( 'aftercopy', function(event) {
    $('#js-copied').addClass('animated FadeIn').show();
    setTimeout(function(){
     $('#js-copied').hide();
   }, 2000);
  } );
}

Products.Form = {

  init: function() {
    Upload.init();
    Products.Form.preview_init();
    Products.Form.currencyInit();
    Products.Form.validate_init();
    Products.Form.init_editor();
    $(".product").on("ajax:success", Products.Form.save);

    if(!EDIT_PRODUCT){
      $(".product").find('input[type=submit]').attr('disabled', 'disabled');
    }
  },
  init_editor: function() {
    $('#product-description').editable({inlineMode: false,
      buttons: ['undo', 'redo' , 'sep', 'bold', 'italic', 'underline', 'fontSize', 'color'
      , 'formatBlock', 'insertOrderedList', 'insertUnorderedList', 'html'],height: 300
    });
  },
  update_product_file: function(file_key) {
    $.ajax({
      url: "/user/products/" + $('#js-product-id').val(),
      type: 'POST',
      dataType: 'json',
      data: { _method: 'patch', product: {file_key: file_key}},
      success: function() {   Up.alert.open('Product file was updated.');}
    });
  },
  save: function(event, data, status, xhr) {
    if(data.product){
     settings.form.attr('action', data.edit_url);
     $('<input>').attr({
      type: 'hidden',
      value: 'patch',
      name: '_method'
    }).appendTo( settings.form);

     $('#js-slug').text(data.slug_url);
     $("#js-ext-link").prop('href', data.slug_url).on('click', function(){
      window.open(data.slug_url, '_blank');
    });
     $('.btn-social-twitter').on('click', function(){
      window.open(data.twitter_url, 'tweet','toolbar=0,status=0,width=600,height=305')
    });
     $('.btn-social-facebook').on('click', function(){
      window.open(data.facebook_url, 'share','toolbar=0,status=0,width=600,height=305')
    });

     ProductsTab.setCompleted('product');
     ProductsTab.switchTo('share');
     if(EDIT_PRODUCT) {
      Up.alert.open('Product was updated.');
    }
    window.EDIT_PRODUCT = true;
    return  true;
  }
},
preview_init: function() {
  $('#js-input-preview').change(Products.Form.preview_add);
  if($("#local-preview-path").val()){
    loadPreview($("#local-preview-path").val());
  }
  if($(".product-form-preview").data('preview-url')){
   window.PREVIEW = true;
   $('.inner-form-preview').css('background-image', 'none');
   loadPreview($(".product-form-preview").data('preview-url'));
 }
},
preview_add: function(e, data) {
  loadPreview(e.target.files[0]);
  $('.inner-form-preview').css('background-image', 'none');
  window.PREVIEW = true;
},

validate: function() {
  var name = $('#product_name').val();
  var price = $('#product_price').val();
  if(name == '') {
    $('#product_name').parent()
    .addClass("has-error")
    .tooltip("destroy")
    .data("title", "Product Name is required")
    .tooltip();
    return false
  }
  if(price == '' || !$.isNumeric(price)) {
    $('#product_price').parent()
    .addClass("has-error")
    .tooltip("destroy")
    .data("title", "Price is required and must be greater than 0.50" + $('#currency').text())
    .tooltip();
    return false

  }
  $('#product_name').parent().removeClass("has-error").tooltip("destroy");
  $('#product_price').parent().removeClass("has-error").tooltip("destroy");
  return true;
},
currencyInit: function() {
  settings.form.find("#currency").bind('click', function(e){
    syms =  settings.form.find("#currency").data('currency-symbols');
    vals =  settings.form.find("#currency").data('currency-values');
    i = $.inArray($(this).text(), syms);
    if(i == (syms.length -1)){
      i =0;
    }else {
      i++;
    }
    settings.form.find("#currency").text(syms[i]);
    settings.form.find("#product_price_currency").val(vals[i]);
  });
},
validate_init: function(){
  $('.product-form').on('submit', Products.Form.validate);
},
show_validation_errors: function(errorMap, errorList) {
  $.each(this.validElements(), function (index, element) {
    var $element = $(element);
    $element.data("title", "")
    .tooltip("destroy");
    $element.parent().removeClass("has-error");
  });
          // Create new tooltips for invalid elements
          $.each(errorList, function (index, error) {
            var $element = $(error.element);
            $element.tooltip("destroy")
            .data("title", error.message)
            .tooltip();
            $element.parent().addClass("has-error");
          });
        }

      }
      function loadPreview(path){
        loadImage(path, function (img) {
          $('#preview').html(img);

        }, {maxHeight: 250, maxWidth: 780, crop: true, canvas: false});
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


    }(jQuery, window.Products = window.Products || {}));
