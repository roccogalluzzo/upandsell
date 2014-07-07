(function ($, Emails, undefined) {

  Emails.New = function() {
    $('#edit').editable({inlineMode: false,
      buttons: ['undo', 'redo' , 'sep', 'bold', 'italic', 'underline', 'fontSize'],
      height: 400,
      placeholder: "Message..."
    });

};

}(jQuery, window.Emails = window.Emails || {}));