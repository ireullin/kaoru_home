class DropLotteryStatistics < ActiveRecord::Migration
  def change
  	drop_table :lottery_statistics
  end
end
