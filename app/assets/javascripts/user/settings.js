(function ($, Settings, undefined) {



  Settings.Payments = function() {
   $("[data-toggle='switch']").change( function(){
     $.ajax({
      url: '/user/settings/update_payments',
      type: 'POST',
      dataType: 'json',
      data: {type: $(this).data('type'), value:  $(this).prop('checked')},
      success: function() {
       Up.alert.open("Setting Saved.")
     },
     error: function() {
       Up.alert.open("Error: We was unable to update this setting.")
     }
   });
   });
 };

 Settings.Setup = function() {
  Setup.init();
}

Settings.Upgrade = function() {
  $.getScript('https://bridge.paymill.com/');
  UpgradePage.init();
}

}(jQuery, window.Settings = window.Settings || {}));
