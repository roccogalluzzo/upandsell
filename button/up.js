/**
 * @param {MessageEvent} event
 * @return {undefined}
 */
 function receiveMessage(event) {
  if (document.getElementById(Gumroad.activeIframeId) && "0" == document.getElementById(Gumroad.activeIframeId).getAttribute("src").indexOf(event.origin)) {
    var name = event.data.split(" ")[0];
    if ("close" == name) {
      Gumroad.close();
    }
  }
}
var Gumroad = Gumroad || {
  urlBlackList : ["/signup", "/login", "/logout", "/admin", "/settings", "/library", "/customers", "/customers_switch_product", "/imported_customers", "/purchases", "/users", "/demo", "/products", "/dashboard", "/analytics", "/balance", "/confirm", "/crossdomain", "/api", "/developers", "/api", "/partnershyp", "/ping", "/webhooks", "/revenue_share", "/jobs", "/team", "/press", "/terms", "/terms_v2", "/privacy", "/blog-posts", "/faq", "/about", "/about", "/how-it-works", "/overlay", "/embed", "/modal",
  "/button", "/next-steps", "/charge", "/charge_data", "/CHARGE", "/examplify", "/deck", "/thank-you", "/guide", "/integrations"],
  init_style: function() {
     //create style button
     var el = document.createElement("style");
     var child = '.gumroad-button { font-family: "Helvetica Neue", Helvetica, Arial, sans-serif !important; font-size: 13px !important; line-height: 17px !important; font-weight: 500 !important; text-align: left !important; color: #8e8e8e !important; text-shadow: 0 1px 2px white !important; border-radius: 3px !important; border: 1px solid #c8c8c8 !important; padding: 4px 6px 4px 26px !important; box-shadow: inset 0 -1px 2px rgba(0, 0, 0, .02), 0 1px 2px rgba(0, 0, 0, .1) !important; text-decoration: none !important; display: inline-block; } .gumroad-button:hover { text-decoration: none !important; color: #777 !important; border-color: #bbb !important; box-shadow: inset 0 -1px 2px rgba(0, 0, 0, .02), 0 1px 2px rgba(0, 0, 0, .1), 0 0 4px rgba(0, 0, 0, .1) !important; } .gumroad-button:active { box-shadow: inset 0 1px 2px rgba(0, 0, 0, .2), inset 0 -1px 2px rgba(0, 0, 0, .02), 0 1px 2px rgba(0, 0, 0, .1) !important; background-color: #fafafa !important; } .gumroad-button strong { color: #666 !important; font-weight: bold !important; }';
     el.type = "text/css";
     if (el.styleSheet) {
      el.styleSheet.cssText = child;
    } else {
      el.appendChild(document.createTextNode(child));
    }
    document.getElementsByTagName("head")[0].appendChild(el);
  },
  init_env: function() {
      // setup Enviroment
      Gumroad.body = document.body;
      Gumroad.development = document.getElementById("modal-p") && "true" == document.getElementById("modal-p").getAttribute("data-gumroad-development");
      Gumroad.staging = document.getElementById("modal-p") && "true" == document.getElementById("modal-p").getAttribute("data-gumroad-staging");
      Gumroad.domain = Gumroad.development ? "http://local.host:3333" : "https://gumroad.com";
      Gumroad.domain = Gumroad.staging ? "http://staging.gumroad.com" : Gumroad.domain;

    },
    init : function() {
    // disable if mobile device
    if (!(navigator.userAgent.match(/Android/i) || (navigator.userAgent.match(/BlackBerry/i) || (navigator.userAgent.match(/iPhone|iPad|iPod/i) || (navigator.userAgent.match(/Opera Mini/i) || navigator.userAgent.match(/IEMobile/i))))) && document.addEventListener) {
      Gumroad.init_style();
      Gumroad.init_env();
      // setup loader gif
      Gumroad.create('<div id="loader" style="position: fixed; z-index: 2000; color: white; top: 50%; left: 50%; margin-top: -32px; margin-left: -32px; text-align: center; height: 64px; width: 64px; background: rgba(0, 0, 0, 1); border-radius: 10px; display: none;"><img src="' + Gumroad.domain + '/overlay-loader.gif" width="32" height="32" style="position: absolute; top: 50%; margin-top: -16px; left: 50%; margin-left: -16px; width: 32px !important; height: 32px !important;"/></div>');
      Gumroad.loadingIndicatorId = "loader";
      Gumroad.loadingIndicator = document.getElementById(Gumroad.loadingIndicatorId);

      Gumroad.fadeDuration = 1E3;
      Gumroad.links = {};

      var codeSegments = document.getElementsByTagName("a");
      var array = Gumroad.development ? ["http://l.h:3333", "http://local.host:3333/l"] : ["http://gum.co/", "https://gum.co/", "https://gumroad.com/l/"];
      array = Gumroad.staging ? ["http://staging.gumroad.com/l/"] : array;
      array = Gumroad.test ? [Gumroad.domain + "l/"] : array;
      var rchecked = new RegExp(Gumroad.domain + "/[^/]+$");
      var i = 0;
      for (;i < codeSegments.length;i++) {
        var anchor = codeSegments[i];
        var value = anchor.getAttribute("href");
        var l = false;
        if (void 0 != value) {
          /** @type {number} */
          var index = 0;
          for (;index < array.length;index++) {
            if (0 === value.lastIndexOf(array[index], 0)) {
              if (1 != l) {
                /** @type {boolean} */
                l = true;
              }
            }
          }
          if (l) {
            new GumroadModal(anchor, "product");
          } else {
            if (rchecked.test(value)) {
              /** @type {boolean} */
              var u = true;
              /** @type {number} */
              var conditionIndex = 0;
              for (;conditionIndex < Gumroad.urlBlackList.length;conditionIndex++) {
                if (0 === value.lastIndexOf(Gumroad.domain + Gumroad.urlBlackList[conditionIndex], 0)) {
                  /** @type {boolean} */
                  u = false;
                  break;
                }
              }
              if (u) {
                new GumroadModal(anchor, "user");
              }
            }
          }
        }
      }
    }
  },

  create : function(html) {

    var g = document.createDocumentFragment();
    var el = document.createElement("div");
    el.innerHTML = "hack" + html;
    for (;el.firstChild;) {
      if (1 === el.firstChild.nodeType) {
        g.appendChild(el.firstChild);
      } else {
        el.removeChild(el.firstChild);
      }
    }
    Gumroad.body.insertBefore(g, Gumroad.body.childNodes[0]);
  },

  remove : function(id) {
    return(elem = document.getElementById(id)).parentNode.removeChild(elem);
  },

  setOpacity : function(element, opacity) {
    return null == element ? false : (element.style.display = 0 == opacity ? "none" : "block", element.style.opacity = opacity, element.style.MozOpacity = opacity, element.style.KhtmlOpacity = opacity, void(element.style.filter = "alpha(opacity=" + 100 * opacity + ");"));
  },
  /**
   * @param {?} id
   * @return {undefined}
   */
   fadeOut : function(id) {
    /** @type {(HTMLElement|null)} */
    var iframe = document.getElementById(id);
    /** @type {number} */
    var opacity = 1;
    /** @type {number} */
    var poll = setInterval(function() {
      opacity -= 100 / Gumroad.fadeDuration;
      Gumroad.setOpacity(iframe, opacity);
      if (0 >= opacity) {
        Gumroad.setOpacity(iframe, 0);
        /** @type {string} */
        iframe.style.display = "none";
        clearInterval(poll);
      }
    }, Gumroad.fadeDuration / 100);
  },
  /**
   * @param {?} id
   * @return {undefined}
   */
   fadeIn : function(id) {
    /** @type {(HTMLElement|null)} */
    var iframe = document.getElementById(id);
    /** @type {number} */
    var opacity = 0;
    /** @type {number} */
    var poll = setInterval(function() {
      opacity += 100 / Gumroad.fadeDuration;
      Gumroad.setOpacity(iframe, opacity);
      if (opacity >= 1) {
        Gumroad.setOpacity(iframe, 1);
        clearInterval(poll);
        iframe.contentWindow.focus();
      }
    }, Gumroad.fadeDuration / 100);
  },
  /**
   * @param {Object} elem
   * @param {string} event
   * @param {Function} fn
   * @param {Object} scope
   * @return {undefined}
   */
   newEvent : function(elem, event, fn, scope) {
    var handle = scope ? function(ev) {
      fn.apply(scope, [ev]);
    } : fn;
    if (document.addEventListener) {
      elem.addEventListener(event, handle, false);
    } else {
      if (document.attachEvent) {
        elem.attachEvent("on" + event, handle);
      }
    }
  },
  /**
   * @param {HTMLDocument} obj
   * @param {?} type
   * @param {?} fn
   * @return {undefined}
   */
   removeEvent : function(obj, type, fn) {
    if (document.removeEventListener) {
      obj.removeEventListener(type, fn, false);
    } else {
      if (document.detachEvent) {
        obj.detachEvent(type, fn);
      }
    }
  },
  /**
   * @param {Object} ev
   * @return {undefined}
   */
   cancelEvent : function(ev) {
    if (ev && ev.preventDefault) {
      ev.preventDefault();
    } else {
      /** @type {boolean} */
      window.event.returnValue = false;
    }
  },
  /**
   * @return {undefined}
   */
   showLoadingIndicator : function() {
    Gumroad.setOpacity(Gumroad.loadingIndicator, 0.6);
  },
  /**
   * @return {undefined}
   */
   hideLoadingIndicator : function() {
    if (Gumroad.loadingIndicator !== false) {
      Gumroad.setOpacity(Gumroad.loadingIndicator, 0);
    }
  },
  /**
   * @return {undefined}
   */
   stopPreviews : function() {
    document.getElementById(Gumroad.activeIframeId).contentWindow.postMessage("stopPreviews", "*");
  },
  /**
   * @param {(Object|string)} e
   * @return {?}
   */
   close : function(e) {
    return void 0 !== e && Gumroad.cancelEvent(e), Gumroad.activeIframeId && (Gumroad.stopPreviews(), Gumroad.fadeOut(Gumroad.activeIframeId), Gumroad.hideLoadingIndicator()), Gumroad.activeIframeId = false, false;
  }
};
GumroadModal = function(el, eventType) {
  var h = el.getAttribute("href");
  var arr = h.split("/");
  var splitUrl = h.split("#");
  /** @type {Node} */
  this.el = el;
  this.id = arr[arr.length - 1].split("?")[0].split("#")[0];
  /** @type {string} */
  this.wanted = "";
  /** @type {string} */
  this.offerCode = "";
  /** @type {string} */
  this.locale = "";
  /** @type {string} */
  this.type = eventType;
  this.hash = splitUrl.length > 1 ? "#" + splitUrl[splitUrl.length - 1] : "";
  if (6 == arr.length && -1 != h.indexOf("/l/") || 5 == arr.length && (-1 != h.indexOf("gum.co") || -1 != h.indexOf("l.h:"))) {
    this.id = arr[arr.length - 2];
    this.offerCode = "/" + arr[arr.length - 1];
  }
  /** @type {string} */
  this.iframeId = "gumroad_" + this.type + "_" + this.id;
  if (h.split("?").length > 1) {
    if (-1 != h.split("?")[1].lastIndexOf("wanted=true")) {
      /** @type {string} */
      this.wanted = "&wanted=true";
    }
  }
  if (h.split("?").length > 1) {
    if (-1 != h.split("?")[1].lastIndexOf("locale=")) {
      this.locale = "&locale=" + h.split("locale=")[1];
    }
  }
  Gumroad.newEvent(this.el, "click", this.show, this);
}, GumroadModal.prototype = {
  /**
   * @param {Object} ev
   * @return {?}
   */
   show : function(ev) {
    if (ev && Gumroad.cancelEvent(ev), Gumroad.showLoadingIndicator(), null == Gumroad.links[this.iframeId]) {
      if ("product" == this.type) {
        Gumroad.create('<iframe class="gumroad_iframe" id="' + this.iframeId + '" src="' + Gumroad.domain + "/l/" + this.id + this.offerCode + "?as_modal=true" + this.wanted + this.locale + "&source_url=" + window.location.href + "&referrer=" + document.referrer + "&" + window.location.search.substring(1) + '" allowtransparency="true" width="100%" height="100%" style="position: fixed !important; overflow: scroll !important; z-index: 1999 !important; top: 0 !important; bottom: 0 !important; right: 0 !important; left: 0 !important; width: 100% !important; height: 100% important; border: none !important; display: none; margin: 0 !important; padding: 0 !important; zoom: 1;"></iframe>')
        ;
      } else {
        if ("user" == this.type) {
          Gumroad.create('<iframe class="gumroad_iframe" id="' + this.iframeId + '" src="' + Gumroad.domain + "/" + this.id + "?as_modal=true" + this.locale + "&source_url=" + window.location.href + "&referrer=" + document.referrer + "&" + window.location.search.substring(1) + this.hash + '" allowtransparency="true" width="100%" height="100%" style="position: fixed !important; overflow: scroll !important; z-index: 1999 !important; top: 0 !important; bottom: 0 !important; right: 0 !important; left: 0 !important; width: 100% !important; height: 100% important; border: none !important; display: none; margin: 0 !important; padding: 0 !important; zoom: 1;"></iframe>')
          ;
        }
      }
      /** @type {boolean} */
      Gumroad.links[this.iframeId] = true;
      /** @type {(HTMLElement|null)} */
      var iframe = document.getElementById(this.iframeId);
      Gumroad.setOpacity(iframe, 0.001);
      Gumroad.newEvent(iframe, "load", this.reallyShowIFrame, this);
    } else {
      /** @type {(HTMLElement|null)} */
      iframe = document.getElementById(this.iframeId);
      iframe.contentWindow.postMessage(this.hash, Gumroad.domain);
      this.reallyShowIFrame();
    }
    return false;
  },
  /**
   * @return {undefined}
   */
   reallyShowIFrame : function() {
    Gumroad.activeIframeId = this.iframeId;
    Gumroad.hideLoadingIndicator();
    Gumroad.fadeIn(this.iframeId);
  }
}, document.onkeydown = function() {
  if (27 == event.keyCode) {
    Gumroad.close();
  }
}, Gumroad.newEvent(window, "load", Gumroad.init), window.addEventListener ? window.addEventListener("message", receiveMessage, false) : window.attachEvent("message", receiveMessage);
