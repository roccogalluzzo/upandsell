(function ($, NewsletterPage, undefined) {



  NewsletterPage.init = function() {

    converter = new Markdown.Converter()
    Markdown.Extra.init(converter)
    editor = new Markdown.Editor(converter)
    editor.run()
  }






}(jQuery, window.NewsletterPage = window.NewsletterPage || {}));
