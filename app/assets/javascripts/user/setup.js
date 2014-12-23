(function ($, Setup, undefined) {

  Setup.Index = function () {
    $('.form-inline').bind("ajax:success", function (evt, data, status, xhr) {
      $('#email').text($('#new-email').val());
      $('#js-email-box').slideUp(300);
    });
    $('#change-email').click(function () {
      $('#js-email-box').slideDown(300);
    });

  };
}($, window.Setup = window.Setup || {}));
