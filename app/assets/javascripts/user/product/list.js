(function ($, ProductsList, undefined) {

  ProductsList.init = function() {
    $('.js-product-share').on('click', ProductsList.actions.share);
    $('.js-p-published').on('change', ProductsList.actions.publish)
  };

  ProductsList.actions = {
    edit: function(){
      window.location.href = $(this).data('url');
      return false;
    },
    share: function(){

    },
    publish: function(){
      jQuery.get($(this).data('url'));
    }
  }
}(jQuery, window.ProductsList = window.ProductsList || {}));
