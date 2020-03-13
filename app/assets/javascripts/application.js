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
//= require turbolinks
//= require_tree .
var chart;
$( document ).ready(function() {

    $("#stats_country").on("change", function() {
        country = $(this).val();
        $(".dyn-title").text("POPULATION EVOLUTION OVER TIME (" + country + ")")
        fetchGraph(country);

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
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero: true
                    }
                }]
            }
        }
    });
    fetchGraph("");
  });


  function fetchGraph(country) {
    fetch('/api/stats?country='+country)
    .then((response) => {
        return response.json();
    })
    .then((data) => {
        var labels = Object.keys(data["recovered"]).sort()
        chart.data.labels = labels;
        let recovered = [];
        let confirmed = [];
        let deaths = [];
        for (i in labels) {
            recovered.push(data['recovered'][labels[i]]);
            confirmed.push(data['confirmed'][labels[i]]);
            deaths.push(data['deaths'][labels[i]]);
        }
        chart.data.datasets = [
            {
                label: 'Recovered',
                backgroundColor: 'transparent',
                borderColor: 'green',
                data: recovered
            },
            {
                label: 'Confirmed',
                backgroundColor: 'transparent',
                borderColor: 'orange',
                data: confirmed
            },
            {
                label: 'Deaths',
                backgroundColor: 'transparent',
                borderColor: 'red',
                data: deaths
            }
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