(function ($, Stats, undefined) {

  Stats.init = function() {
    window.s = { range: $(".product"), chart: {}, period: 'day'};
    Stats.Tab.init();
    AmCharts.ready(Stats.graph.init);
    $('select').on('change', Stats.data.product_get);
 };

 Stats.graph = {
   init: function() {
     Stats.data.onload_get();
   },
   refresh: function(data) {
     s.chart.dataProvider = data;
     if(s.period == 'week' || s.period == 'month') {
     s.chart.categoryAxis.minPeriod = "DD";
   }else {
     s.chart.categoryAxis.minPeriod = "hh";
   }
     s.chart.validateData();
     Stats.Tab.toggle_loading();
   },
   load: function(data) {

     s.chart = new AmCharts.AmSerialChart();
     var currency = $('#js-graph-canvas').data('currency');
     s.chart.dataProvider = data;
     s.chart.categoryField = 'date';
     //s.chart.dataDateFormat = 'DD-MMMM-YYYY';
     s.chart.color = '#4B0082';
     s.chart.fontSize = 13;
     s.chart.theme = 'dark';
     s.chart.categoryAxis.parseDates = true;
     s.chart.categoryAxis.minPeriod = "hh";
     s.chart.chartCursor = {};
     s.chart.trendLines = [];
     s.chart.marginLeft = 10;
     s.chart.marginRight = 10;
     s.chart.marginTop = 10;
     s.chart.marginBottom = 10;
     s.chart.balloon = {
       "cornerRadius": 5,
       "fillAlpha": 1
     }

     // Earnings Graph
     graph = new AmCharts.AmGraph();
     graph.title = "Earnings";
     graph.valueField = "earnings";
     graph.type = "line";
     graph.lineThickness = 3;
     graph.lineAlpha = 1;
     graph.fillAlphas = 0.10;
     graph.lineColor = '#454D60';
     graph.bullet = 'bubble';
     graph.balloonText = "<p class='balloon-earnings'>[[value]]" + currency + "</p><p class='balloon-sales'><i class='fa  fa-shopping-cart'></i> [[sales]]</p><p class='balloon-visits'><i class='fa fa-eye'></i> [[visits]]</p>";
     graph.creditsPosition = "bottom-right";

     s.chart.addGraph(graph);

     // value
     var valueAxis = new AmCharts.ValueAxis();
     valueAxis.stackType = "regular";
     valueAxis.gridAlpha = 0;
     valueAxis.axisAlpha = 0;
     valueAxis.gridThickness = 0;
     s.chart.addValueAxis(valueAxis);

     // Sales Graph
     graph = new AmCharts.AmGraph();
     graph.title = "Sales";
     graph.labelText = "[[value]]";
     graph.valueField = "sales";
     graph.type = "column";
     graph.lineAlpha = 0;
     graph.fillAlphas = 1;
     graph.lineColor = "#d0eae7";
     graph.showBalloon = false
     s.chart.addGraph(graph);

     // first graph
     var graph = new AmCharts.AmGraph();
     graph.title = "Visits";
     graph.labelText = "[[value]]";
     graph.valueField = "visits";
     graph.type = "column";
     graph.lineAlpha = 0;
     graph.fillAlphas = 1;
     graph.lineColor = "#addad5";
     graph.showBalloon = false;
     s.chart.addGraph(graph);

     s.chart.write('js-graph-canvas');
     Stats.Tab.toggle_loading();
 }
};
Stats.data = {
   get: function(period) {
     Stats.Tab.toggle_loading();
     s.period = period;
   var params = {period: period, products: $('select').val()};
   jQuery.getJSON('/user/dashboard/metrics', params, Stats.data.update);
  },
  product_get: function() {
    Stats.Tab.toggle_loading();
    var params = {period: s.period, products: $('select').val()};
    jQuery.getJSON('/user/dashboard/metrics', params, Stats.data.update);
  },
  onload_get: function() {
    Stats.Tab.toggle_loading();
    var params = {type: 'earnings', range: 30, products: $('select').val()};
    jQuery.getJSON('/user/dashboard/onload_metrics', params, Stats.data.create_graph);
  },
  create_graph: function(d) {
    $('#js-earnings-today').text(d.earnings.today/100);
    $('#js-earnings-week').text(d.earnings.week/100);
    $('#js-earnings-month').text(d.earnings.month/100);
    $('#js-visits').text(d.visits);
    $('#js-sales').text(d.sales);
    $('#js-conversion-rate').text(d.conversion_rate);
    Stats.graph.load(d.graph_data);
    if(d.demo == true){
      Stats.Tab.set_demo();
    }
  },
  update: function(d) {
    $('#js-visits').text(d.visits);
    $('#js-sales').text(d.sales);
    $('#js-conversion-rate').text(d.conversion_rate);
    Stats.graph.refresh(d.graph_data);
    if(d.demo == true){
      Stats.Tab.set_demo();
    }
  }
};

Stats.Tab = {
  init: function() {
    $('.dashboard-tab').on('click', Stats.Tab.click);
  },
  click: function() {
    Stats.Tab.set_active(this);
    Stats.data.get($(this).data('period'));
  },
  set_active: function(el) {
    console.log(el);
    $('.dashboard-tab').each(function() {
      $(this).removeClass('active-tab');
    });
    $(el).addClass('active-tab');
  },
  toggle_loading: function() {
    $('#loading-graph').fadeToggle(400);
    $('#demo-graph').fadeOut(400);
  },
  set_demo: function() {
    $('#demo-graph').fadeIn(400);
  }
}




}(jQuery, window.Stats = window.Stats || {}));
