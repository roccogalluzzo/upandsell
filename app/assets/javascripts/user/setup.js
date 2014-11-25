(function ($, Setup, undefined) {
    var settings = {};
    window.EU_COUNTRIES = ['AT', 'BE', 'BG', 'CY', "DK", "EE", "FI", "FR", "DE", "GR",
                            "IE", "IT", "LV", "LT", "LU", "MT", "NL", "PL", "PT", "GB", "CZ", "RO",
                            "SK", "SI", "ES", "SE", "HU"]

    window.lang = {
        company_it: 'Partita IVA',
        private_it: 'Codice Fiscale',
        company_eu: 'VAT ID'
    }
    function init_settings() {
        settings = {
            type_label: $("label[for='user_legal_name']"),
            tax_id_label: $("label[for='user_tax_code']")
        };
        return settings;
    }

    Setup.Index = function () {
        $('.form-inline').bind("ajax:success", function (evt, data, status, xhr) {
            $('#email').text($('#new-email').val());
            $('#js-email-box').slideUp(300);
        });
        $('#change-email').click(function () {
            $('#js-email-box').slideDown(300);
        });

    };

    Setup.Billing_details = function () {
        s = init_settings();
        Setup.BillingForm.init();
    };

    Setup.BillingForm = {
        init: function () {
            $("select").addClass('form-control select select-primary select-block').select2({style: 'btn btn-primary', menuStyle: 'dropdown-default'});
            $(':radio').radiocheck();
            Setup.BillingForm.validation.init();
            $('#user_country').on('change', Setup.BillingForm.update_fields);
             $("input[name='user[business_type]']:radio").on('change', Setup.BillingForm.update_fields);
            Setup.BillingForm.update_fields();
        },
        update_fields: function () {
            type = $("input[name='user[business_type]']:checked").val();
            country = $('#user_country').val();

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
                $('#user_cc_number').payment('formatCardNumber');
                $('#user_cc_expire').payment('formatCardExpiry');
                $('#user_cc_cvc').payment('formatCardCVC');
                $.validator.addMethod("ccNumberValid", $.payment.validateCardNumber, " Credit Card Number is Invalid.");
                $.validator.addMethod("ccExpValid", Setup.BillingForm.validation.ccExpValid, " Credit Card Data is Invalid.");
                $('form').validate({
                    //submitHandler: Setup.BillingForm.submit,
                    showErrors: Setup.BillingForm.validation.showErrors,
                    errorPlacement: Setup.BillingForm.validation.errorPlacement,
                    success: Setup.BillingForm.validation.success,
                    highlight: Setup.BillingForm.validation.highlight,
                    unhighlight: Setup.BillingForm.validation.unhighlight,
                    rules: Setup.BillingForm.validation.rules
                });
            },
            ccExpValid: function (value) {
                var data = $.payment.cardExpiryVal(value);
                return $.payment.validateCardExpiry(data.month, data.year);
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
            }
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
            "cc-num" : { ccNumberValid : true,
                        required: true
                       },
            "cc-email": {
                required: true,
                email: true
            },
            "cc-exp": {
                required: true,
                ccExpValid: true
            },
            "cc-cvc": {
                required: true,
                digits: true,
                minlength: 3,
                maxlength: 4
            }
        },
    }
}($, window.Setup = window.Setup || {}));