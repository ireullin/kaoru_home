class CreateRoboticFarmMonitors < ActiveRecord::Migration
  def change
    create_table :robotic_farm_monitors do |t|
      t.string :group_id
      t.string :seq
      t.float :air_hum
      t.float :air_tmp
      t.float :soil_hum
      t.float :lux
      t.timestamps
    end
  end
end
