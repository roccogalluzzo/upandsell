(function ($, Stats, undefined) {

  var settings = {};
  function init_settings() {
    settings = { range: $(".product"), graph: null};
  }

  Stats.init = function() {

    data = formatData($('.graph').data('earnings'));
    //buildSummaryChart('js-earnings', data);
    options = {
      animation: true,
      responsive: true,
      maintainAspectRatio: true
    }
    new Chart(document.getElementById("canvas").getContext("2d")).Line(data, options);

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
  var x = [];
  var labels = []
  console.log(data)
  $.each(data, function(timestamp, d) {
    labels.push(moment(timestamp).format('YYYY-MM-D'));
    x.push(d.earnings + 100 )
 });
  return {labels: labels, datasets: [
    {
      fillColor : "rgba(220,220,220,0.5)",
      strokeColor : "rgba(220,220,220,1)",
      pointColor : "rgba(220,220,220,1)",
      pointStrokeColor : "rgba(220,220,220,1)",
      data : x,
  //    xPos : labels,
      title : "With xPos"
    }
    ]}
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
    lineColors:['#d0eae7'],
    pointFillColors: ['#9bd2cc'],
    pointStrokeColors: ['#9bd2cc'],
    lineWidth:'0',
    grid: false,
    axes: false,
    fillOpacity:'1',
    resize: true,
    hoverCallback: function (index, options, content) {
      var row = options.data[index];
      date = moment(row.x).format('D MMMM YYYY');

      return  "<b class='text-center'>" + date + "</b><br /> <b>" + row.y + '</b> '
      + $('.graph').data('currency')  + '<br /><b>' + row.z + ' </b>SALES';
    }
  });

}


}(jQuery, window.Stats = window.Stats || {}));
