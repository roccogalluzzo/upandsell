(function ($, Accounts, undefined) {

 Accounts.Edit = function() {
  $('#user_password').on('input',function(e){
   $('#password_confirmation').slideDown(300);
   $('#current_password').slideDown(300);
   // $('.fa-lock').removeClass('hidden');
   });
}
}(jQuery, window.Accounts = window.Accounts || {}));