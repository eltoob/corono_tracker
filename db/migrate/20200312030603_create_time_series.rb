class CreateTimeSeries < ActiveRecord::Migration[5.2]
  def change
    create_table :time_series do |t|
      t.string :region
      t.string :country
      t.date :date
      t.string :metric
      t.string :lat
      t.string :long
      t.integer :count
      t.timestamps
    end
  end
end
