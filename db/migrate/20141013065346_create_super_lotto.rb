class CreateSuperLotto < ActiveRecord::Migration
  def change
    create_table :superlottos, {:id => false, :primary_key => :term} do |t|
    	t.string :term, {:null => false}
    	t.integer :no1, {:null => false}
    	t.integer :no2, {:null => false}
    	t.integer :no3, {:null => false}
    	t.integer :no4, {:null => false}
    	t.integer :no5, {:null => false}
    	t.integer :no6, {:null => false}
    	t.integer :special, {:null => false}
    	t.date :announced_at, {:null => false}
    	t.timestamps :created_at
    end
  end
end
