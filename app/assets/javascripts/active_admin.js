//= require active_admin/base
//= require jquery.ui.widget
//= require jquery.iframe-transport
//= require jquery.fileupload
//= require highcharts
//= require underscore

$(document).ready(function() {

  if($('#chart-1').length) {
    $.getJSON('/admin/dashboard/chart', function (data) {
      orders = _.map(data, function(data){
        return [Date.parse(data.date), parseInt(data.orders_count)]
      });

      cards = _.map(data, function(data){
        return [Date.parse(data.date), parseInt(data.cards_count)]
      });

      $('#chart-1').highcharts({
        title: { text: 'Ordrar & Gåvobevis' },
        xAxis: { type: 'datetime' },
        yAxis: {
          title: { text: 'Antal' },
          min: 0
        },
        plotOptions: {
          column: {
            grouping: false
          }
        },
        series: [
        {
          type: 'column',
          name: 'Gåvobevis',
          data: cards,
          color: Highcharts.getOptions().colors[3],
        },
        {
          type: 'column',
          name: 'Ordrar',
          data: orders,
        },
        ]
      });
    });
  }

});
