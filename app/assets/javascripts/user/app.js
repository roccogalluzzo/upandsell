(function ($, Up, undefined) {

  Up.init = function() {
    if ($("#js-message").text().length > 20) { Up.alert.open();}
    $("select").select2({style: 'btn btn-primary', menuStyle: 'dropdown-default'});

    if($("select").data('selected')){
     $('.selectpicker').select2('val', $("select").data('selected'));
   }

   $("[data-toggle='switch']").bootstrapSwitch();
   var page = Utils.getPage();
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
     top: 55
   }, 500);
    setTimeout(Up.alert.close, 5000);
  },
  close: function() {
    $('.animated-alert').animate({
     top: -15
   }, 500);

  }
}

}(jQuery, window.Up = window.Up || {}));