

function SummaryChart(containerid, raw_data) {

  function data(data) {
    var rval = {key: 'Earnings', values: []};
    $.each(data, function(timestamp, value) {
     rval.values.push({x: timestamp, y: value/100});
   });
    return [rval];
  }
  nv.addGraph(function() {
    var chart;
    chart = nv.models.linePlusBarChart();
    chart.x(function(d,i) {
      return d.x;
    });

    chart.tooltip = function(key, x, y, e, graph) {
      return '<div class="tooltip-inner">' +
      '<h3><i class="fa fa-calendar"></i>' + x + '</h3>' +
      '<p>' + y + '</p>' +
      '</div><div class="tooltip-arrow"></div>';
    }
    var formatter;
    formatter = function(d,i) {
      if(i > 0){ return ''}
        now = new Date(d*1000);
      return d3.time.format('%d %b %Y')(now);
    }

    chart.showLegend = false;
    chart.xAxis
    .tickFormat(
      formatter
      );
    chart.yAxis
    .tickFormat(function(d) { return '$' + d3.format('')(d) });
    chart.color(['#3498db']);
    d3.select('#' + containerid + ' svg')
    .datum(data(raw_data))
    .transition().duration(500)
    .call(chart);
    nv.utils.windowResize(chart.update);
    return chart;
  });
}

function  redrawSummaryChart(id, data) {
  $(id + ' svg').empty();
  SummaryChart(id, data)

}




