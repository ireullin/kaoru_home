class CreateSupperlottosRanks < ActiveRecord::Migration
  def change
    create_table :supperlottos_ranks do |t|
      t.text :content

      t.timestamps
    end
  end
end
