(function ($, Stats, undefined) {

  var settings = {};
 function init_settings() {
  settings = { range: $(".product")};
}

Stats.init = function() {
  $('select').on('change', function() {
   console.log($(this).val())
   $.ajax({
    url: '/user/products/metrics',
    type: 'GET',
    dataType: 'json',
    data: {type: 'earnings', range: $(".period-selector li.active a").data('action'),
    products: $('select').val()},
    async: false,
    success: function(d) {
      console.log(d);
      $('.earnings_count').text(d.earnings[0]);
      $('.visits_count').text(d.visits[0]);
      $('.sales_count').text(d.sales[0]);
      redrawSummaryChart("dashboard_chart", d.earnings[1]) }
    });
 });

  $('a[data-toggle="pill"]').on('shown.bs.tab', function (e) {
    $.ajax({
      url: '/user/products/metrics',
      type: 'GET',
      dataType: 'json',
      data: {type: 'earnings', range: $(e.target).data('action'),
      products: $('select').val()},
      async: false,
      success: function(d) {
        console.log(d);
        $('.earnings_count').text(d.earnings[0]);
        $('.visits_count').text(d.visits[0]);
        $('.sales_count').text(d.sales[0]);
        redrawSummaryChart("dashboard_chart", d.earnings[1]) }
      });
  })

}


}(jQuery, window.Stats = window.Stats || {}));