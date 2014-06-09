(function(doc, s) {
  /** @type {Element} */
  s = doc.createElement("script");
  s.setAttribute("src", "up.js");
  doc.getElementsByTagName("head")[0].appendChild(s);
})(document);