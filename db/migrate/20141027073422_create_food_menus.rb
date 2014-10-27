class CreateFoodMenus < ActiveRecord::Migration
  def change
    create_table :food_menus, :id => false do |t|
    	t.string :type
     	t.text :context 
    	t.datetime :created_at
    	t.datetime :updated_at
    end
  end
end
