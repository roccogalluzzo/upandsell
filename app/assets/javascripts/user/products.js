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
  Products.init();
  Products.Form.init();
};

Products.Edit = function() {
  Products.init();
  Products.Form.init();
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
    Products.Form.currencyInit();
    Products.Form.validationInit();
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
