class CreateSupperlottosCounts < ActiveRecord::Migration
  def change
    create_table :supperlottos_counts do |t|
    	t.integer :no1
    	t.integer :no1_cnt

    	t.integer :no2
    	t.integer :no2_cnt

    	t.integer :no3
    	t.integer :no3_cnt

    	t.integer :no4
    	t.integer :no4_cnt

    	t.integer :no5
    	t.integer :no5_cnt

    	t.integer :no6
    	t.integer :no6_cnt

    	t.integer :special
    	t.integer :special_cnt

    	t.timestamps
    end
  end
end
