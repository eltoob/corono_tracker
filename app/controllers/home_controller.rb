class HomeController < ApplicationController
  def index
  end

  def stats
    country = params[:countries]
    if country.empty?
      @tss = [TimeSeries.time_series_worldwide]
    else
      @tss = [TimeSeries.time_series_per_location(country)]
    end
    render json: @tss
  end
end
