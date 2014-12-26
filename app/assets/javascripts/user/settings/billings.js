(function ($, Billings, undefined) {

  var settings = {};
  window.EU_COUNTRIES = ['AT', 'BE', 'BG', 'CY', "DK", "EE", "FI", "FR", "DE", "GR", "IE", "IT", "LV", "LT", "LU", "MT", "NL", "PL", "PT", "GB", "CZ", "RO", "SK", "SI", "ES", "SE", "HU"]

  window.lang = {
    company_it: 'Partita IVA',
    private_it: 'Codice Fiscale',
    company_eu: 'VAT ID',
    name_company: 'Company Name',
    name_private: 'Your Full Name (First and last name)'
  }
  function init_settings() {
    settings = {
      name_label: $("label[for='user_legal_name']"),
      tax_id_label: $("label[for='user_tax_code']")
    };
    return settings;
  }

  Billings.New = function () {
    s = init_settings();
    Billings.BillingForm.init();
  };

  Billings.Edit = function () {
    s = init_settings();
    window.edit = true;
    Billings.BillingForm.init();
    $('#js-toggle-billing-form').on('click', function(){
      $('#billing-edit-form').fadeToggle();
      return false;
    });
    $('#cc_number').rules( "remove", 'required');
    $('#cc_expire').rules( "remove", 'required');
    $('#cc_cvc').rules( "remove", 'required');
  }
  Billings.BillingForm = {
    init: function () {
      $("select").addClass('form-control select select-primary select-block').select2({style: 'btn btn-primary', menuStyle: 'dropdown-default'});
      $(':radio').radiocheck();
      Billings.BillingForm.validation.init();
      $('#user_country').on('change', Billings.BillingForm.update_fields);
      $("input[name='user[business_type]']:radio").on('change', Billings.BillingForm.update_fields);
      Billings.BillingForm.update_fields();
      $('form').bind('ajax:beforeSend', Billings.BillingForm.success);
      $('form').bind('ajax:success', Billings.BillingForm.success);
      $('form').bind('ajax:error', Billings.BillingForm.error);
      $('#js-change-price').on('click',  Billings.BillingForm.change_price);
    },
    change_price: function() {
      cur_month = $('.month-price').text();
      cur_year = $('.year-price').text();
      $('.month-price').text($(this).data('switch-month'));
      $('.year-price').text($(this).data('switch-year'));

      $(this).data('switch-month', cur_month);
      $(this).data('switch-year', cur_year);

      cur_text = $(this).text();
      $(this).text( $(this).data('text'));
      $(this).data('text', cur_text);
      return false;
    },
    beforeSend: function(data) {

    },
    success: function(e, data) {
    },
    error: function(e, xhr, status) {

    },
    submit: function() {
      $('.btn-action').attr("disabled", "disabled");
      expire = $('#cc_expire').payment('cardExpiryVal');
      if(expire) {
      Stripe.card.createToken({
        number:  $('#cc_number').val().replace(/\s+/g, ''),
        cvc:  $('#cc_cvc').val(),
        exp_month: expire.month,
        exp_year: expire.year
      }, Billings.BillingForm.stripe);
    }else {
      var $form = $('form');
      $form.trigger("submit.rails");
    }
      return false;
    },
    stripe: function(status, response) {
      var $form = $('form');
      if (response.error) {
        Up.alert.open(response.error.message);
        return false
      } else {
        $('#user_stripe_token').val(response.id);
        $form.trigger("submit.rails");
      }
    },
    update_fields: function () {
      type = $("input[name='user[business_type]']:checked").val();
      country = $('#user_country').val();

      if(type == 'company') {
        s.name_label.text(window.lang.name_company);
      }else{
        s.name_label.text(window.lang.name_private);
      }

      // Italy logic
      if (country == 'IT'){
        $('.user_tax_code').fadeIn();
        if(type == 'company') {
          s.tax_id_label.text(window.lang.company_it);
        }else{
          s.tax_id_label.text(window.lang.private_it);
        }
      }
      else if($.inArray(country, window.EU_COUNTRIES) >= 0) {
        if(type == 'company') {
          $('.user_tax_code').fadeIn();
          s.tax_id_label.text(window.lang.company_eu);
        }else{
          $('.user_tax_code').fadeOut();
        }
      }else {
        $('.user_tax_code').fadeOut();
      }

    },
    validation: {
      init: function () {
        $('#cc_number').payment('formatCardNumber');
        $('#cc_expire').payment('formatCardExpiry');
        $('#cc_cvc').payment('formatCardCVC');
        $.validator.addMethod("ccNumberValid", Billings.BillingForm.validation.ccNumberValid, " Credit Card Number is Invalid.");
        $.validator.addMethod("ccExpValid", Billings.BillingForm.validation.ccExpValid, " Credit Card Data is Invalid.");
        $('form').validate({
          submitHandler: Billings.BillingForm.submit,
          showErrors: Billings.BillingForm.validation.showErrors,
          errorPlacement: Billings.BillingForm.validation.errorPlacement,
          success: Billings.BillingForm.validation.success,
          highlight: Billings.BillingForm.validation.highlight,
          unhighlight: Billings.BillingForm.validation.unhighlight,
          rules: Billings.BillingForm.validation.rules
        });
      },
      ccExpValid: function (value) {
        if(value === "") { return true}
        var data = $.payment.cardExpiryVal(value);
        return $.payment.validateCardExpiry(data.month, data.year);

      },
      ccNumberValid: function (value) {
        if(value === "") { return true}
          return $.payment.validateCardNumber(value);
      },
      showErrors: function (errorMap, errorList) {
        $.each(this.validElements(), function (index, element) {
          var $element = $(element);
          $element.data("title", "")
          .tooltip("destroy");

          $element.next()
          .removeClass('hidden text-error fa-times')
          .addClass('fa-check text-success');

          $element.parent().removeClass("has-error");
        });

        $.each(errorList, function (index, error) {
          var $element = $(error.element);
          $element.tooltip("destroy")
          .data("title", error.message)
          .data("placement", "bottom")
          .tooltip();

          $element.parent().addClass("has-error");

          $element.next()
          .removeClass('hidden text-success fa-check')
          .addClass('fa-times text-error');
        });
      },
      errorPlacement: function (error, element) {
        $(element).next()
        .removeClass('hidden text-success fa-check')
        .addClass('fa-times text-error');
      },
      success: function (label, element) {
        $(element).next()
        .removeClass('hidden text-error fa-times')
        .addClass('fa-check text-success');
        $(element).parent().addClass("has-success");
      },
      highlight: function (element, errorClass, validClass) {
        $(element).parent().addClass("has-error");
      },
      unhighlight: function (element, errorClass, validClass) {
        $(element).parent().removeClass("has-error");
      },
      rules : {
        "user[tax_code]": {
          required: "#user_tax_code:visible",
        },
        "user[zip_code]": {
          required: true,
          digits: true
        },
        "user[cc_number]" : {
          ccNumberValid : true,
          required: true
        },
        "user[cc_expire]": {
          required: true,
          ccExpValid: true
        },
        "user[cc_cvc]": {
          required: true,
          digits: true,
          minlength: 3,
          maxlength: 4
        }
      },
    }
  }
}(jQuery, window.Billings = window.Billings || {}));
