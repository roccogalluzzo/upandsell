(function ($, Up, undefined) {

  Up.init = function() {
    if ($("#js-message").text().length > 20) { Up.alert.open();}
    $("select").selectpicker({style: 'btn btn-primary', menuStyle: 'dropdown-default'});
    $(".select").removeClass('form-control');
    $("[data-toggle='switch']").wrap('<div class="switch" />').parent().bootstrapSwitch();
    var page = Utils.getPage();
    console.log(page.controller.capitalize(), page.action.capitalize())
    try {
     window[page.controller.capitalize()][page.action.capitalize()]();
   } catch(e) {
  // fail silently
}

};

Up.alert = {
  open: function(message) {
    $('#js-message').text(message);
    $('.animated-alert').animate({
     top: 60
   }, 500);
    setTimeout(Up.alert.close, 4500);
  },
  close: function() {
    $('.animated-alert').animate({
     top: -15
   }, 500);

  }
}

}(jQuery, window.Up = window.Up || {}));