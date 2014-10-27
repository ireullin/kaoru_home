class RenameFoodmenu < ActiveRecord::Migration
  def change
  		rename_column :food_menus, :type, :food_type
  end
end
