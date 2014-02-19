defaultChartConfig("dashboard_chart", data(),true, true, {forceY:false});



function defaultChartConfig(containerid, data, guideline, useDates, auxOptions) {
  if (auxOptions === undefined) auxOptions = {};
  if (guideline === undefined) guideline = true;
  nv.addGraph(function() {
    var chart;
    chart = nv.models.linePlusBarChart();

    chart.x(function(d,i) {
      return d.x;
    });

    if (auxOptions.width)
      chart.width(auxOptions.width);

    if (auxOptions.height)
      chart.height(auxOptions.height);

    if (auxOptions.forceY)
      chart.forceY([0]);
chart.tooltip = function(key, x, y, e, graph) {
    return '<div class="tooltip-inner">' +
     '<h3><i class="fa fa-calendar"></i>' + x + '</h3>' +
     '<p>' + y + '</p>' +
     '</div><div class="tooltip-arrow"></div>';
   }
    var formatter;
    formatter = function(d,i) {
      if(i > 0){ return ''}
      now = new Date(d);
      return d3.time.format('%d %b %Y')(now);
    }

    if (auxOptions.width)
      chart.width(auxOptions.width);

    if (auxOptions.height)
      chart.height(auxOptions.height);
    chart.showLegend = false;
    chart.xAxis
    .tickFormat(
      formatter
      );
chart.yAxis
        .tickFormat(function(d) { return '$' + d3.format('')(d) });
    chart.color(['#3498db']);

    d3.select('#' + containerid + ' svg')
    .datum(data)
    .transition().duration(500)
    .call(chart);

    nv.utils.windowResize(chart.update);

    return chart;
  });
}


function data(days) {
  days = days|| 30;

  function views(key, days, isArea) {
   var rval = {key: key, values: []};
   if (isArea) rval.area = true;
   for(var i = 1; i < days; i++) {
     date = new Date("05/" + i + "/2013").getTime();
     number = Math.floor(Math.random() * 500);
     rval.values.push({x: date, y: number});
   }
   return rval;
 }

 var stocks = [];
 var views = views("VIEWS", days);
 stocks.push(views);
 return stocks;
}

