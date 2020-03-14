// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require waves
//= require turbolinks
//= require_tree .
var chart;
$( document ).ready(function() {

    $("#stats_country").on("select2:select", function() {
        country = $(this).val();
        $(".dyn-title").text("POPULATION EVOLUTION OVER TIME (" + country + ")")
        $('#stats_region').val(null).trigger('change')
        fetchGraph(country, "");

    })
    $("#stats_region").on("select2:select", function() {
        region = $(this).val();
        $(".dyn-title").text("POPULATION EVOLUTION OVER TIME (" + region + ")")
        fetchGraph("", region);

    })
    var ctx = document.getElementById('myChart').getContext('2d');
    chart = new Chart(ctx, {
        // The type of chart we want to create
        type: 'line',
    
        // The data for our dataset
        data: {
            // labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
            // datasets: [{
            //     label: 'My First dataset',
            //     backgroundColor: 'transparent',
            //     borderColor: 'rgb(255, 99, 132)',
            //     data: [0, 10, 5, 2, 20, 30, 45]
            // }]
        },
    
        // Configuration options go here
        options: {
            
        }
    });
    fetchGraph("", "");
  });


  function fetchGraph(country, region) {
    fetch('/api/stats?country='+country+"&region="+region)
    .then((response) => {
        return response.json();
    })
    .then((data) => {
        var labels = Object.keys(data["recovered"]).sort()
        chart.data.labels = labels;
        let recovered = [];
        let confirmed = [];
        let deaths = [];
        let infected = [];
        let susceptibles = [];
        for (i in labels) {
            recovered.push(data['recovered'][labels[i]]);
            confirmed.push(data['confirmed'][labels[i]]);
            deaths.push(data['deaths'][labels[i]]);
            infected.push(data['confirmed'][labels[i]] - data['recovered'][labels[i]] - data['deaths'][labels[i]]);
        }
        chart.data.datasets = [
            {
                label: 'Recovered',
                backgroundColor: 'transparent',
                borderColor: 'green',
                data: recovered,
                
            },
            {
                label: 'Infected',
                backgroundColor: 'transparent',
                borderColor: 'red',
                data: infected
            },
            {
                label: 'Deaths',
                backgroundColor: 'transparent',
                borderColor: 'black',
                data: deaths,
            },
        ]

        chart.update();
    });
  }


  $( document ).ready(function() {
    fetch('https://www.reddit.com/r/China_Flu/top/.json?count=1')
    .then((response) => {
        return response.json();
    })
    .then((data) => {
         
        var title = data.data.children[0].data.title;
        var url = data.data.children[0].data.url;
        $(".main-news").text(title)
        $(".read-link").attr("href", url);
        $(".main-alert").show();
    });

  });


  $(document).ready(function() {
    $('#stats_country').select2();
    $('#stats_region').select2();
    
});


