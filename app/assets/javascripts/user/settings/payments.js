(function ($, Payments, undefined) {

 Payments.Edit = function() {
  $("[data-toggle='switch']").change( function(){
   $.ajax({
    url: '/user/settings/payments',
    type: 'POST',
    dataType: 'json',
    data: {_method:'PATCH', type: $(this).data('type'), value:  $(this).prop('checked')},
    success: function() {
     Up.alert.open("Setting Saved.")
   },
   error: function() {
     Up.alert.open("Error: We was unable to update this setting.")
   }
 });
 });
}
}(jQuery, window.Payments = window.Payments || {}));