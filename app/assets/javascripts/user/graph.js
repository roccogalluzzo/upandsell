

function SummaryChart(containerid, raw_data) {
	Morris.Area({
	  element: 'area-example',
	  data: [
		{ y: '2006', a: 100, b: 90 },
		{ y: '2007', a: 75,  b: 65 },
		{ y: '2008', a: 50,  b: 40 },
		{ y: '2009', a: 75,  b: 65 },
		{ y: '2010', a: 50,  b: 40 },
		{ y: '2011', a: 75,  b: 65 },
		{ y: '2012', a: 100, b: 90 }
	  ],
	  xkey: 'y',
	  ykeys: ['a', 'b'],
	  labels: ['Series A', 'Series B'],
	  lineColors:['#0090d9','#b7c1c5'],
	  lineWidth:'0',
	   grid:'false',
	  fillOpacity:'0.5'
	});

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




