(function ($, Utils, undefined) {

  settings = {page:{}}

  Utils.registerPage = function(controller, action) {
    settings.page.controller = controller;
    settings.page.action = action;
  };

  Utils.getPage = function() {
    return {controller: settings.page.controller, action: settings.page.action};
  };

  String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
  }

}(jQuery, window.Utils = window.Utils || {}));