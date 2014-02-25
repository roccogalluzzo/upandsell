
nv.models.linePlusBarChart = function() {
  "use strict";
  //============================================================
  // Public Variables with Default Settings
  //------------------------------------------------------------

  var multibar = nv.models.multiBar()
  , xAxis = nv.models.axis()
  , yAxis = nv.models.axis()
  , legend = nv.models.legend()
  ;

  var margin = {top: 30, right: 60, bottom: 50, left: 60}
  , width = null
  , height = null
  , getX = function(d) { return d.x }
  , getY = function(d) { return d.y }
  , color = nv.utils.defaultColor()
  , showLegend = false
  , tooltips = true
  , tooltip = function(key, x, y, e, graph) {
    return '<div class="tooltip-inner">' +
     '<h3><i class="fa fa-calendar"></i> ' + x + '</h3>' +
     '<p>' + y + '</p>' +
     '</div><div class="tooltip-arrow"></div>';
  }
  , x
  , y
  , state = {}
  , defaultState = null
  , noData = "No Data Available."
  , dispatch = d3.dispatch('tooltipShow', 'tooltipHide', 'stateChange', 'changeState')
  ;

  multibar
  .stacked(true)
  .stackOffset('wiggle')
  ;
  xAxis
  .orient('bottom')
  .tickPadding(7)
  .highlightZero(false)
  .height = 20
  ;
  yAxis
  .orient('left')
  ;


  //============================================================


  //============================================================
  // Private Variables
  //------------------------------------------------------------

  var showTooltip = function(e, offsetElement) {
    var left = e.pos[0] + ( offsetElement.offsetLeft || 0 ),
    top = e.pos[1] + ( offsetElement.offsetTop || 0),
    x = xAxis.tickFormat()(multibar.x()(e.point, e.pointIndex)),
    y = yAxis.tickFormat()(multibar.y()(e.point, e.pointIndex)),
    content = tooltip(e.series.key, x, y, e, chart);

    nv.tooltip.show([left, top], content, e.value < 0 ? 'n' : 's', null, offsetElement);
  }
  ;

  //------------------------------------------------------------



  function chart(selection) {
    selection.each(function(data) {
      var container = d3.select(this),
      that = this;

      var availableWidth = (width  || parseInt(container.style('width')) || 960)
      - margin.left - margin.right,
      availableHeight = (height || parseInt(container.style('height')) || 400)
      - margin.top - margin.bottom;

      chart.update = function() { container.transition().call(chart); };
      // chart.container = this;

      //set state.disabled
      state.disabled = data.map(function(d) { return !!d.disabled });

      if (!defaultState) {
        var key;
        defaultState = {};
        for (key in state) {
          if (state[key] instanceof Array)
            defaultState[key] = state[key].slice(0);
          else
            defaultState[key] = state[key];
        }
      }

      //------------------------------------------------------------
      // Display No Data message if there's nothing to show.

      if (!data || !data.length || !data.filter(function(d) { return d.values.length }).length) {
        var noDataText = container.selectAll('.nv-noData').data([noData]);

        noDataText.enter().append('text')
        .attr('class', 'nvd3 nv-noData')
        .attr('dy', '-.7em')
        .style('text-anchor', 'middle');

        noDataText
        .attr('x', margin.left + availableWidth / 2)
        .attr('y', margin.top + availableHeight / 2)
        .text(function(d) { return d });

        return chart;
      } else {
        container.selectAll('.nv-noData').remove();
      }

      //------------------------------------------------------------


      //------------------------------------------------------------
      // Setup Scales

      var dataBars = data.filter(function(d) { return !d.disabled && d.bar });

       //x = dataBars.filter(function(d) { return !d.disabled; }).length && dataBars.filter(function(d) { return !d.disabled; })[0].values.length ? bars.xScale() : multibar.xScale();
     //x = dataLines.filter(function(d) { return !d.disabled; }).length && dataLines.filter(function(d) { return !d.disabled; })[0].values.length ? lines.xScale() : multibar.xScale();
      x =  multibar.xScale(); //old code before change above
      y = multibar.yScale();

      //------------------------------------------------------------

      //------------------------------------------------------------
      // Setup containers and skeleton of chart

      var wrap = d3.select(this).selectAll('g.nv-wrap.nv-linePlusBar').data([data]);
      var gEnter = wrap.enter().append('g').attr('class', 'nvd3 nv-wrap nv-linePlusBar').append('g');
      var g = wrap.select('g');

      gEnter.append('g').attr('class', 'nv-x nv-axis');
      gEnter.append('g').attr('class', 'nv-y nv-axis');
      gEnter.append('g').attr('class', 'nv-y2 nv-axis').append("line");
       gEnter.append('g').attr('class', 'nv-x-0 nv-axis').append("line");
      gEnter.append('g').attr('class', 'nv-barsWrap');
      gEnter.append('g').attr('class', 'nv-linesWrap');
      gEnter.append('g').attr('class', 'nv-legendWrap');

      //------------------------------------------------------------


      //------------------------------------------------------------
      // Legend

      if (showLegend) {
        legend.width( availableWidth / 2 );

        g.select('.nv-legendWrap')
        .datum(data.map(function(series) {
          series.originalKey = series.originalKey === undefined ? series.key : series.originalKey;
          series.key = series.originalKey + (series.bar ? ' (left axis)' : ' (right axis)');
          return series;
        }))
        .call(legend);

        if ( margin.top != legend.height()) {
          margin.top = legend.height();
          availableHeight = (height || parseInt(container.style('height')) || 400)
          - margin.top - margin.bottom;
        }

        g.select('.nv-legendWrap')
        .attr('transform', 'translate(' + ( availableWidth / 2 ) + ',' + (-margin.top) +')');
      }

      //------------------------------------------------------------


      wrap.attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');


      //------------------------------------------------------------
      // Main Chart Component(s)

      multibar
      .disabled(data.map(function(series) { return series.disabled }))
      .width(availableWidth)
      .height(availableHeight)
      .color(data.map(function(d,i) {
        return d.color || color(d, i);
      }).filter(function(d,i) { return !data[i].disabled }))


      var barsWrap = g.select('.nv-barsWrap')
      .datum(data.filter(function(d) { return !d.disabled }))

      barsWrap.transition().call(multibar);




      //------------------------------------------------------------


      //------------------------------------------------------------
      // Setup Axes

      xAxis
      .scale(x)
      .ticks( availableWidth / 100 )
      .tickSize(-availableHeight, 0)
      .margin( {bottom: 100});

      g.select('.nv-x.nv-axis')
      .attr('transform', 'translate(0,' + y.range()[0] + ')');
      d3.transition(g.select('.nv-x.nv-axis'))
      .call(xAxis);
      yAxis
      .scale(y)
      .ticks( availableHeight / 36 )
      .tickSize(-availableWidth, 0);

      d3.transition(g.select('.nv-y.nv-axis'))
      .style('opacity', 1)
      .call(yAxis);
g.select('.nv-y .nv-wrap')
.select('.nv-axisMaxMin text').attr('y', '-10');
  g.select('.nv-y2.nv-axis line')

            .attr('transform',
              'translate('+ availableWidth +', 0)')
                         .attr("x2", 0)
                         .attr("y2", availableHeight);


  g.select('.nv-x-0.nv-axis line')
  .attr('transform',
              'translate(-50, '+ availableHeight +')')
                         .attr("x2", availableWidth +100)
                         .attr("y2", 0);
      //------------------------------------------------------------


      //============================================================
      // Event Handling/Dispatching (in chart's scope)
      //------------------------------------------------------------

      legend.dispatch.on('stateChange', function(newState) {
        state = newState;
        dispatch.stateChange(state);
        chart.update();
      });

      dispatch.on('tooltipShow', function(e) {
        if (tooltips) showTooltip(e, that.parentNode);
      });


      // Update chart from a state object passed to event handler
      dispatch.on('changeState', function(e) {

        if (typeof e.disabled !== 'undefined') {
          data.forEach(function(series,i) {
            series.disabled = e.disabled[i];
          });

          state.disabled = e.disabled;
        }

        chart.update();
      });

      //============================================================


    });

return chart;
}


  //============================================================
  // Event Handling/Dispatching (out of chart's scope)
  //------------------------------------------------------------
  multibar.dispatch.on('elementMouseover.tooltip', function(e) {
    e.pos = [e.pos[0] +  margin.left, e.pos[1] + margin.top];
    dispatch.tooltipShow(e);
  });

  multibar.dispatch.on('elementMouseout.tooltip', function(e) {
    dispatch.tooltipHide(e);
  });



  dispatch.on('tooltipHide', function() {
    if (tooltips) nv.tooltip.cleanup();
  });

  //============================================================


  //============================================================
  // Expose Public Variables
  //------------------------------------------------------------

  // expose chart's sub-components
  chart.dispatch = dispatch;
  chart.legend = legend;
 chart.multibar = multibar;
  chart.xAxis = xAxis;
  chart.yAxis = yAxis;

  d3.rebind(chart, 'defined', 'size', 'clipVoronoi', 'interpolate');
  //TODO: consider rebinding x, y and some other stuff, and simply do soemthign lile bars.x(lines.x()), etc.
  //d3.rebind(chart, lines, 'x', 'y', 'size', 'xDomain', 'yDomain', 'xRange', 'yRange', 'forceX', 'forceY', 'interactive', 'clipEdge', 'clipVoronoi', 'id');

  chart.options = nv.utils.optionsFunc.bind(chart);

  chart.x = function(_) {
    if (!arguments.length) return getX;
    getX = _;

    multibar.x(_);
    return chart;
  };

  chart.y = function(_) {
    if (!arguments.length) return getY;
    getY = _;

    bars.y(_);
    return chart;
  };

  chart.margin = function(_) {
    if (!arguments.length) return margin;
    margin.top    = typeof _.top    != 'undefined' ? _.top    : margin.top;
    margin.right  = typeof _.right  != 'undefined' ? _.right  : margin.right;
    margin.bottom = typeof _.bottom != 'undefined' ? _.bottom : margin.bottom;
    margin.left   = typeof _.left   != 'undefined' ? _.left   : margin.left;
    return chart;
  };

  chart.width = function(_) {
    if (!arguments.length) return width;
    width = _;
    return chart;
  };

  chart.height = function(_) {
    if (!arguments.length) return height;
    height = _;
    return chart;
  };

  chart.color = function(_) {
    if (!arguments.length) return color;
    color = nv.utils.getColor(_);
    legend.color(color);
    return chart;
  };

  chart.showLegend = function(_) {
    if (!arguments.length) return showLegend;
    showLegend = _;
    return chart;
  };

  chart.tooltips = function(_) {
    if (!arguments.length) return tooltips;
    tooltips = _;
    return chart;
  };

  chart.tooltipContent = function(_) {
    if (!arguments.length) return tooltip;
    tooltip = _;
    return chart;
  };

  chart.state = function(_) {
    if (!arguments.length) return state;
    state = _;
    return chart;
  };

  chart.defaultState = function(_) {
    if (!arguments.length) return defaultState;
    defaultState = _;
    return chart;
  };

  chart.noData = function(_) {
    if (!arguments.length) return noData;
    noData = _;
    return chart;
  };

  //============================================================


  return chart;
}
