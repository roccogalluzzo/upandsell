(function ($, Stats, undefined) {

  var settings = {};
 function init_settings() {
  settings = { range: $(".product"), graph: null};
}

Stats.init = function() {

  data = formatData($('.graph').data('earnings'));
  buildSummaryChart('area-example', data);

  $('select').on('change', function() {
   $.ajax({
    url: '/user/dashboard/metrics',
    type: 'GET',
    dataType: 'json',
    data: {type: 'earnings', range: 30,
    products: $('select').val()},
    async: false,
    success: function(d) {
      console.log(d);
      $('.earnings-today').text(d.earnings.today/100);
      $('.earnings-week').text(d.earnings.week/100);
      $('.earnings-month').text(d.earnings.month/100);
      $('.visits-month').text(d.visits);
      $('.sales-month').text(d.sales);
      $('.conversion-rate').text(d.conversion_rate);

       updateSummaryChart(d.earnings.summary_data)
     }
    });
 });

}

function updateSummaryChart(data) {

 settings.graph.setData(formatData(data));

}

function formatData(data) {
    var rval = [];
    console.log(data)
    $.each(data, function(timestamp, d) {
     rval.push({x: moment(timestamp).format('YYYY-MM-D'), y: d.earnings/100, z: d.sales});
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
  labels: ['Earnings'],
  hideHover: true,
  lineColors:['#0090d9','#b7c1c5'],
  lineWidth:'0',
  grid: false,
  axes: false,
  fillOpacity:'0.5',
  hoverCallback: function (index, options, content) {
  var row = options.data[index];
       date = moment(row.x).format('D MMMM YYYY');

  return  "<b class='text-center'>" + date + "</b><br /> <b>" + row.y + '</b> '
  + $('.graph').data('currency')  + '<br /><b>' + row.z + ' </b>SALES';
}
});

}


}(jQuery, window.Stats = window.Stats || {}));
