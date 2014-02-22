(function ($, Product, undefined) {

 var settings = {};
 function init_settings() {
  settings = { form: $(".product")};
}

Product.init = function() {
  init_settings();
  Product.Upload.file();
  Product.Upload.filePreview();
  Product.Form.currencyInit();
  Product.Form.validationInit();
};


Product.Form = {
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
        submitHandler: function(form) {
          if(form.find( "input[class=upload_uuid]" ).val()){
            form.submit();
        }
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

function fileError(action){
  if(action == 'hide'){
    $('.file-error').addClass('hidden');
    $('.file-row-error').removeClass('file-row-error');
  }else {
    $('.file-error').removeClass('hidden');
    $('.file-row-error').addClass('file-row-error');
  }
}


}(jQuery, window.Product = window.Product || {}));
