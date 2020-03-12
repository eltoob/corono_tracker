class HomeController < ApplicationController
  def index
  end

  def stats
    country = params[:country]
    region = params[:region]
    if country.present?
      @ts = TimeSeries.time_series_per_country(country)
    elsif region.present?
      @ts = TimeSeries.time_series_per_region(region)
    else
      @ts = TimeSeries.time_series_worldwide
    end
    render json: @ts
  end
end
