(function ($, AccountPage, undefined) {

  AccountPage.init = function() {
    AccountPage.Form.init();
  }

  AccountPage.Form = {
    init: function() {
      $('#user_password').on('input',function(e){
       $('#password_confirmation').slideDown(300);
       $('#current_password').slideDown(300);
       //$('.fa-lock').removeClass('hidden');
     });

      AccountPage.Form.setValidation();
    }
  }

}(jQuery, window.AccountPage = window.AccountPage || {}));
