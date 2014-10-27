class CreateDrink < ActiveRecord::Migration
  def change
    create_table :drinks, :id => false do |t|
    	t.text :context 
    	t.datetime :created_at
    	t.datetime :updated_at
    end
  end
end
