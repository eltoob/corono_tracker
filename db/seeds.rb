# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

recovered_file = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"
confirmed_file = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
deaths_file = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"

confirmed_us_file = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
death_us_file = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv"


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

deaths_us = read(death_us_file)
confirmed_us = read(confirmed_us_file)


ActiveRecord::Base.transaction do
    TimeSeries.delete_all
    puts "Loading recovered"
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


    puts "Loading Confirmed"
    confirmed.each do |r|
        r.each do |k,val|
            if  k[0].to_i.to_s == k[0]
                date =  Date.strptime(k, '%m/%d/%y')
                TimeSeries.create(
                    region: r["Province/State"], 
                    country: r["Country/Region"],
                    date: date,
                    metric: "confirmed",
                    lat: r["Lat"],
                    long: r["Long"],
                    count: val.to_i,
                )
            end
        end
    end

    puts "Loading Deaths"
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

    puts "Loading Deaths in the US"
    deaths_us.each do |r| 
        r.each do |k,val|
            if  k[0].to_i.to_s == k[0]
                date =  Date.strptime(k, '%m/%d/%y')
                TimeSeries.create(
                    region: r["Combined_Key"], 
                    country: '',
                    date: date,
                    metric: "deaths",
                    lat: r["Lat"],
                    long: r["Long"],
                    count: val.to_i,
                )
            end
        end
    end

    puts "Loading Confirmed in the US"
    confirmed_us.each do |r| 
        r.each do |k,val|
            if  k[0].to_i.to_s == k[0]
                date =  Date.strptime(k, '%m/%d/%y')
                TimeSeries.create(
                    region: r["Combined_Key"], 
                    country: '',
                    date: date,
                    metric: "confirmed",
                    lat: r["Lat"],
                    long: r["Long"],
                    count: val.to_i,
                )
            end
        end
    end

    
end