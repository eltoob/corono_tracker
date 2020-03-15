class TimeSeries < ApplicationRecord
    scope :recovered, -> { where(metric: 'recovered') }
    scope :confirmed, -> { where(metric: 'confirmed') }
    scope :deaths, -> { where(metric: 'deaths') }
    scope :current, -> {where(date: last_date_available)}

    def self.last_date_available
        return self.where("count > 0").order(:date).last.date
    end

    def self.current_ts
        last_date_available = self.last_date_available
        ts_recovered = where(date: last_date_available).recovered
        ts_confirmed = where(date: last_date_available).confirmed
        ts_deaths = where(date: last_date_available).deaths

        return {
            ts_recovered: ts_recovered,
            ts_confirmed: ts_confirmed,
            ts_deaths: ts_deaths,
        }
    end


    def self.current_worldwide
        ts = self.current_ts
        return {
            recovered: ts[:ts_recovered].map(&:count).sum,
            confirmed: ts[:ts_confirmed].map(&:count).sum,
            deaths: ts[:ts_deaths].map(&:count).sum,
        }
    end


    def self.all_countries
        return TimeSeries.distinct.pluck(:country) + ["world"]
    end

    def self.all_regions
        return TimeSeries.distinct.pluck(:region) + ["world"]
    end


    def self.current_by_country
        all_countries = self.all_countries
        res = []
        recovered_by_country = TimeSeries.current.group(:country).recovered.sum(:count)
        confirmed_by_country = TimeSeries.current.group(:country).confirmed.sum(:count)
        deaths_by_country = TimeSeries.current.group(:country).deaths.sum(:count)
        all_countries.each do |c|
            if c != 'world'
                res.push({
                    country: c,
                    confirmed: confirmed_by_country[c],
                    recovered: recovered_by_country[c],
                    deaths: deaths_by_country[c]
                })
            end
        end
        return res.sort_by{ |p| p[:confirmed] }.reverse()
    end
    

    def self.current_by_region
        all_regions = self.all_regions
        res = []
        recovered_by_region = TimeSeries.current.group(:region).recovered.sum(:count)
        confirmed_by_region = TimeSeries.current.group(:region).confirmed.sum(:count)
        deaths_by_region = TimeSeries.current.group(:region).deaths.sum(:count)
        all_regions.each do |r|
            if r != 'world'
                res.push({
                    region: r,
                    confirmed: confirmed_by_region[r],
                    recovered: recovered_by_region[r],
                    deaths: deaths_by_region[r]
                })
            end
        end
        return res.sort_by{ |p| p[:confirmed] }.reverse()
    end

    def self.time_series_per_region(region)
        if region == 'world'
            return self.time_series_worldwide
        end
        return {
            recovered: self.where(region: region).group(:date).recovered.sum(:count),
            confirmed: self.where(region: region).group(:date).confirmed.sum(:count),
            deaths: self.where(region: region).group(:date).deaths.sum(:count)
        }
    end

    def self.time_series_per_country(country)
        if country == 'world'
            return self.time_series_worldwide
        end
        return {
            recovered: self.where(country: country).group(:date).recovered.sum(:count),
            confirmed: self.where(country: country).group(:date).confirmed.sum(:count),
            deaths: self.where(country: country).group(:date).deaths.sum(:count)
        }
    end

    def self.time_series_worldwide
        return {
            recovered: self.group(:date).recovered.sum(:count),
            confirmed: self.group(:date).confirmed.sum(:count),
            deaths: self.group(:date).deaths.sum(:count)
        }
    end

    def self.time_series_per_location(location)
        if location.empty?
            return self.time_series_worldwide
        elsif self.all_countries.include?(location)
            return self.time_series_per_country(location)
        elsif self.all_regions.include?(location)
            return self.time_series_per_region(location)
        else
            return []
        end
    end

end
