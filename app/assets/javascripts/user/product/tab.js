(function ($, ProductsTab, undefined) {

  ProductsTab.switchTo = function(tab, status) {
    $('#js-' + tab + '-tab')
    .removeClass('disabled-tab completed-tab')
    .addClass('active-tab')
    .tab('show');
    $('.' + tab).addClass('animated fadeIn')
  };

  ProductsTab.setCompleted = function(tab) {
    $('#js-' + tab + '-tab')
    .removeClass('disabled-tab')
    .removeClass('active-tab')
    .addClass('completed-tab')
    .find('i')
    .removeClass()
    .addClass('fa fa-check animated bounceIn');
  };
  ProductsTab.setDisabled = function(tab) {
    $('#js-' + tab + '-tab')
    .removeClass('completed-tab active-tab')
    .addClass('disabled-tab');
  };


}(jQuery, window.ProductsTab = window.ProductsTab || {}));
