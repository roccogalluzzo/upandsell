(function ($, Coupons, undefined) {

  Coupons.init = function() {
    $( "#datepicker" ).datepicker({minDate: 1,
      dateFormat: "dd/mm/yy"});
    $( "#coupon_available" ).spinner();

  };

  Coupons.Index = function() {
    Coupons.init();
    Coupons.Events.init();
    setProduct();
    setProductDiscount(PRODUCT.price, PRODUCT.currency);

  };

  Coupons.Events = {
   init: function(){
     $("#js-new-coupon-btn").on('click', Coupons.animations.show_form);
     $('#coupon_discount').on('keyup', Coupons.Events.discount_key_up);
     $('#js-product-select').on('change', Coupons.Events.select_product);
     $('#js-coupon-random').on('click', Coupons.Events.random_code);
     $('#js-coupon-type-btn').on('click', Coupons.Events.coupon_type);
   },
   discount_key_up: function(){
     calculateDiscount($(this).val(), $('#js-coupon-type').val());
   },
   select_product: function(){
    setProduct();
    setProductDiscount(PRODUCT.price, PRODUCT.currency);
    calculateDiscount( $('#coupon_discount').val(), $('#js-coupon-type').val());
  },
  random_code: function(){
    $('#coupon_code').val(Math.random().toString(36).substr(2, 5).toUpperCase());
    return false;
  },
  coupon_type: function(){
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
    calculateDiscount( $('#coupon_discount').val(), $('#js-coupon-type').val());
    return false;
  }
};

Coupons.animations = {
 show_form: function(){
  $(".js-coupon-form").slideDown(300);
  $(".js-coupon-msg").slideUp(300);

},
hide_form: function(){
  $(".js-coupon-form").slideUp(300);
  $(".js-coupon-msg").slideDown(300);

}
};

function calculateDiscount(off, type){
  if(type == 'cents'){
    var new_price = (PRODUCT.price - off).toFixed(2);
  }else {
    var new_price = (PRODUCT.price - ((off/100)*PRODUCT.price)).toFixed(2);
  }

  if(new_price < 0 || new_price > window.PRODUCT.price) {
    $('#js-product-price').addClass('text-error');
     $('#js-product-price').text("Err...");
  }else {
    $('#js-product-price').removeClass('text-error');
      $('#js-product-price').text(new_price);
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


}(jQuery, window.Coupons = window.Coupons || {}));