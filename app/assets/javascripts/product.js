(function ($, Product, undefined) {

 var settings = {};
 function init_settings() {
  settings = { form: $(".simple_form")};
}

Product.init = function() {
  init_settings();
  Product.Form.currencyInit();
  Product.Upload.file();
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
