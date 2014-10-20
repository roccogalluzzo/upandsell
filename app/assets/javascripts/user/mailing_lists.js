(function ($, Mailing_lists, undefined) {

 Mailing_lists.Show = function() {
   NewsletterPage.init();
 }



 Mailing_lists.Index = function() {
  $('#js-createsend-switch').on('switchChange.bootstrapSwitch', function(event, state) {
    if($(this).is(':checked')){
      $('.createsend-integration').removeClass('unfocused');
    }else{
     $('.createsend-integration').addClass('unfocused');
   }
 });

  $('#js-mailchimp-switch').on('switchChange.bootstrapSwitch', function(event, state) {
    if($(this).is(':checked')){
      $('.mailchimp-integration').removeClass('unfocused');
    }else{
     $('.mailchimp-integration').addClass('unfocused');
   }
 });

  var mailchimp = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/user/tools/mailing_lists/search?q=%QUERY',
      ajax: {
        beforeSend: function(xhr, settings) {
          $("#js-search-mailchimp").removeClass('hid');
        },
        complete: function(xhr, status) {
          $("#js-search-mailchimp").addClass('hid');
        }
      }
    }
  });

  mailchimp.initialize();


  $('#the-basics .typeahead').typeahead({
    hint: true,
    highlight: true,
    minLength: 1,
  },
  {
    displayKey: 'name',
    source:  mailchimp.ttAdapter()
  })
  .bind('typeahead:selected', function(obj, datum, name) {
   console.log(datum, name);
    // setttare ml id ad un campo hidden o roba simile
    $('#js-mailing-list-id').val(datum.id);
  });

  $('#js-createsend-clients-list').on('change', function() {
   $("#js-load-cs-list").removeClass('hid');
   $.getJSON('/user/tools/mailing_lists/createsend_lists',
   {
    cs_client_id:  $(this).val()
  },
  function(result){
    var options =  $('#js-createsend-select-list');
    options.empty();
    $.each(result, function() {
      options.append($("<option />").val(this.ListID).text(this.Name));
    });
  //  options.select2('refresh');
    $("#js-load-cs-list").addClass('hid');
    $('#js-createsend-list-name').val(
      $("#js-createsend-select-list option:selected").text()
      );
  });
 });
  $('#js-createsend-select-list').on('change', function() {
    $('#js-createsend-list-name').val(
      $("#js-createsend-select-list option:selected").text()
      );
  });


  $("#js-new-list-btn").on('click', function(){
    Mailing_lists.animations.show_form();
    $("#js-load-cs-client").removeClass('hid');
    $.getJSON('/user/tools/mailing_lists/createsend_clients',
      function(result){
        var options =  $('#js-createsend-clients-list');
        $.each(result, function() {
          options.append($("<option />").val(this.ClientID).text(this.Name));
        });
        $("#js-load-cs-client").addClass('hid');
      //  options.select2('refresh');
      });

  });



  Mailing_lists.animations = {
   show_form: function(){
    $("#js-new-list-form").slideDown(300);
    $("#js-new-list-msg").slideUp(300);

  },
  hide_form: function(){
    $("#js-new-list-form").slideUp(300);
    $("#js-new-list-msg").slideDown(300);

  },
  show_list: function(provider, html){
    $("#js-" + provider + "-list table").html(html);
    $("#js-" + provider + "-list").slideDown(500);
    Mailing_lists.animations.sync_on_click(provider);
  },
  refresh_list: function(provider, html){
    console.log(provider, html);
    $("#js-" + provider + "-list table").fadeOut(500, function(){
      Mailing_lists.animations.show_list(provider, html);
      $(this).fadeIn(500);
    });
  },
  hide_list: function(provider) {
    $("#js-" + provider + "-list").slideUp(500);
  },
  show_completed: function(provider) {
    $("#js-sync-" + provider + "-completed").removeClass('hid').slideDown(600);
    $("#js-sync-search").slideUp(600);
    $(".modal-footer").slideUp(600);
  },
  hide_completed: function(provider) {
    $("#js-sync-" + provider + "-completed").slideUp(600);
  },
  show_removed: function(provider) {
    $("#js-sync-" + provider + "-removed").slideDown(600);
    setTimeout(
      function() {
        $("#js-sync-" + provider + "-removed").fadeOut(500);
        Mailing_lists.animations.show_search_message(provider);
        $("#js-sync-search").slideDown(500);
        $(".modal-footer").slideDown(500);
      }, 3000);
  },
  show_search_message: function(provider){
    $("#js-" + provider + "-search-message").slideDown(500);
  },
  hide_search_message: function(provider){
   $("#js-" + provider + "-search-message").slideUp(500);
 },
 select: function(el){
  el.text('Selected');
  $(".btn-select-list").not(el).addClass('disabled')
  .parent().parent().css('opacity', '0.4');
  $('#js-sync-btn').removeClass('disabled');
  $("#js-provider-id-sync").val($(el).data('list-id'));
  $("#js-provider-name-sync").val($(el).data('list-name'));
},
deselect: function(el){
  $(".btn-select-list").not(el).removeClass('disabled')
  .parent().parent().css('opacity', '1');
  $(el).text('Select');
  $('#js-sync-btn').addClass('disabled');
  $("#js-provider-id-sync").val('');
},
sync_on_click: function(provider){
  $(".btn-select-list").on('click', function(){
    if($(this).text() == 'Selected'){
      Mailing_lists.animations.deselect($(this));
    }else {
      Mailing_lists.animations.select($(this));
    }
    return false;
  });
}
}
}
}(jQuery, window.Mailing_lists = window.Mailing_lists || {}));
