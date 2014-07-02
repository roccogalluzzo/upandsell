(function ($, NewsletterPage, undefined) {



  NewsletterPage.init = function() {
    $('#edit').editable({inlineMode: false,
      buttons: ['undo', 'redo' , 'sep', 'bold', 'italic', 'underline', 'fontSize'],
      height: 400,
      placeholder: "Message..."
    })
  }






}(jQuery, window.NewsletterPage = window.NewsletterPage || {}));
