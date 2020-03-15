class HomeController < ApplicationController
  def index
  end

  def stats

    countries = params[:countries].split(",")
    @tss = []
    countries.each do |country|
      @tss.push(TimeSeries.time_series_per_location(country))
    end
    if countries.empty?
      @tss.push(TimeSeries.time_series_worldwide)
    end
    render json: @tss
  end
end
