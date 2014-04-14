(function ($, Up, undefined) {

  Up.init = function() {
   var page = Utils.getPage();
   try {
     window[page.controller.capitalize()][page.action.capitalize()]();
   } catch(e) {
  // fail silently
}
};

}(jQuery, window.Up = window.Up || {}));