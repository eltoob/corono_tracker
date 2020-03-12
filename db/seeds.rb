# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

recovered_file = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv"
confirmed_file = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv"
deaths_file = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv"


require 'rubygems'
require 'open-uri'
require 'csv'

def read(url)
    csv_text = open(url)
    
    return CSV.parse(csv_text, :headers=>true)
end

recovered = read(recovered_file)
confirmed = read(confirmed_file)
deaths = read(deaths_file)


ActiveRecord::Base.transaction do
    TimeSeries.delete_all
    recovered.each do |r|
        r.each do |k,val|
            if  k[0].to_i.to_s == k[0]
                date =  Date.strptime(k, '%m/%d/%y')
                TimeSeries.create(
                    region: r["Province/State"], 
                    country: r["Country/Region"],
                    date: date,
                    metric: "recovered",
                    lat: r["Lat"],
                    long: r["Long"],
                    count: val.to_i,
                )
            end
            puts r["Province/State"]
        end
    end



    confirmed.each do |r|
        r.each do |k,val|
            if  k[0].to_i.to_s == k[0]
                date =  Date.strptime(k, '%m/%d/%y')
                TimeSeries.create(
                    region: r["Province/State"], 
                    country: r["Country/Region"] || r["Province/State"],
                    date: date,
                    metric: "confirmed",
                    lat: r["Lat"],
                    long: r["Long"],
                    count: val.to_i,
                )
            end
        end
    end

    deaths.each do |r|
        r.each do |k,val|
            if  k[0].to_i.to_s == k[0]
                date =  Date.strptime(k, '%m/%d/%y')
                TimeSeries.create(
                    region: r["Province/State"], 
                    country: r["Country/Region"],
                    date: date,
                    metric: "deaths",
                    lat: r["Lat"],
                    long: r["Long"],
                    count: val.to_i,
                )
            end
        end
    end
end