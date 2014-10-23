class WeatherChangeColumn < ActiveRecord::Migration
  def change
  	add_column :weathers, :city, :string
  	remove_column :weathers, :id

  end
end
