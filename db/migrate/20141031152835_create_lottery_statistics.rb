class CreateLotteryStatistics < ActiveRecord::Migration
  def change
    create_table :lottery_statistics, :id => false do |t|
    	t.string :statistic_type
      	t.text :context 
      	t.text :description
    	t.datetime :created_at
    	t.datetime :updated_at
    end
  end
end
