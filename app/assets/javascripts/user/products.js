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
  ZeroClipboard.config( { moviePath: '/ZeroClipboard.swf' } );
  var client = new ZeroClipboard(element);
}

Products.Form = {

  init: function() {
    Upload.init();
    Products.Form.preview_init();
    Products.Form.currencyInit();
    Products.Form.validationInit();

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
  save: function(event, data, status, xhr) {
    if(data.product){
      el.form.attr('action', data.edit_url);
      $('<input>').attr({
        type: 'hidden',
        value: 'patch',
        name: '_method'
      }).appendTo(el.form);

      $('#js-slug').text(data.slug_url);
      $("#js-ext-link").attr('href', data.slug_url);
      $('.btn-social-twitter').on('click', function(){
        window.open(data.twitter_url, 'tweet','toolbar=0,status=0,width=600,height=305')
      });
      $('.btn-social-facebook').on('click', function(){
        window.open(data.facebook_url, 'share','toolbar=0,status=0,width=600,height=305')
      });
      $('.share').removeClass('hid');

      ProductsTab.setCompleted('product');
      ProductsTab.switchTo('share');
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
validationInit: function(){
  settings.form.validate({
    showErrors: function(errorMap, errorList) {

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
            console.log($element.parent())
            $element.parent().addClass("has-error");
          });
        },
        rules: {
          "product[price]": {
            required: true,
            number: true,
            min: 0.50
          }
        }
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
