(function ($, Stats, undefined) {

  var settings = {};
 function init_settings() {
  settings = { range: $(".product"), graph: null};
}

Stats.init = function() {

  data = formatData($('.graph').data('earnings'));
  buildSummaryChart('area-example', data);

  $('select').on('change', function() {
   console.log($(this).val())
   $.ajax({
    url: '/user/products/metrics',
    type: 'GET',
    dataType: 'json',
    data: {type: 'earnings', range: 30,
    products: $('select').val()},
    async: false,
    success: function(d) {
      console.log(d);
      $('.earnings-today').text(d.earnings["today"]/100);
      $('.earnings-week').text(d.earnings.week/100);
      $('.earnings-month').text(d.earnings.month[0]/100);
      $('.visits-month').text(d.visits[0]);
      $('.sales-month').text(d.sales[0]);
      $('.conversion-rate').text(d.conversion_rate);

       updateSummaryChart(d.earnings.month[1])
     }
    });
 });

}

function updateSummaryChart(data) {

 settings.graph.setData(formatData(data));

}

function formatData(data) {
    var rval = [];
    $.each(data, function(timestamp, value) {
     rval.push({x: (timestamp * 1000), y: value/100});
   });
    return rval;
  }


function buildSummaryChart(element, data) {

  settings.graph = Morris.Area({
  element: element,
  data:  data,
  xkey: 'x',
  ykeys: 'y',
  ymin: 0,
  labels: ['Earnings', 'Series B'],
  hideHover: true,
  lineColors:['#0090d9','#b7c1c5'],
  lineWidth:'0',
  grid: false,
  axes: false,
  fillOpacity:'0.5'
});

}


}(jQuery, window.Stats = window.Stats || {}));
