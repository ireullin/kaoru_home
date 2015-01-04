class CreateLottery649sRanks < ActiveRecord::Migration
  def change
    create_table :lottery649s_ranks do |t|
    	t.text :content
      	t.timestamps
    end
  end
end
