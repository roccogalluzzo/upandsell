(function ($, Dashboard, undefined) {

  Dashboard.Index = function() {
   Stats.init();
   var map = new Datamap({element: document.getElementById('world')});
 };

}(jQuery, window.Dashboard = window.Dashboard || {}));
