class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.date :weather_date
      t.string :des
      t.float :max
      t.float :min

      t.timestamps
    end
  end
end
