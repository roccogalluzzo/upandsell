(function ($, Coupons, undefined) {

  Coupons.Index = function() {
    $( "#datepicker" ).datepicker({minDate: 1,
      dateFormat: "dd/mm/yy"});
   $( "#coupon_available" ).spinner();

   setProduct();
   setProductDiscount(PRODUCT.price, PRODUCT.currency);


     $("#js-new-coupon-btn").on('click', function(){
    Coupons.animations.show_form();

  });

   $('#coupon_discount').on('keyup', function(){
    calculateDiscount($(this).val(), $('#js-coupon-type').val());
  });
   $('#js-product-select').on('change', function(){
    setProduct();
    setProductDiscount(PRODUCT.price, PRODUCT.currency);
  });
   $('#js-coupon-random').on('click', function(){
    $('#coupon_code').val(Math.random().toString(36).substr(2, 5).toUpperCase());
    return false;
  });
   $('#js-coupon-type-btn').on('click', function(){
    var type = $(this).find('span');
    if(type.text() == '%') {
      type.text(window.PRODUCT.currency);
      $('#js-coupon-type').val('cents');
      $('#coupon_discount').prop('max', window.PRODUCT.price);
      $('#coupon_discount').prop('step', '0.01');
    }else {
      type.text('%');
      $('#js-coupon-type').val('percent');
      $('#coupon_discount').prop('max', '100');
      $('#coupon_discount').prop('step', '1');
    }
    return false;
  });
 };

 function calculateDiscount(off, type){
  if(type == 'cents'){
   $('#js-product-price').text((PRODUCT.price - off).toFixed(2));
 }else {
   $('#js-product-price').text((PRODUCT.price - ((off/100)*PRODUCT.price)).toFixed(2));
 }
}

function setProductDiscount(price, currency) {
  $('#js-product-price').text(price);
  $('#js-product-currency').text(currency);
}

function setProduct(){
 window.PRODUCT = {
  el: $('#js-product-select').find(':selected'),
  price:  $('#js-product-select').find(':selected').data('price'),
  currency: $('#js-product-select').find(':selected').data('currency')
};
}

  Coupons.animations = {
   show_form: function(){
    $("#js-new-coupon-form").slideDown(300);
    $("#js-new-coupon-msg").slideUp(300);

  },
  hide_form: function(){
    $("#js-new-coupon-form").slideUp(300);
    $("#js-new-coupon-msg").slideDown(300);

  }

  };

}(jQuery, window.Coupons = window.Coupons || {}));