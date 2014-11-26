class CreateMoneyNoteHistories < ActiveRecord::Migration
  def change
    create_table :money_note_histories do |t|
      t.string :category
      t.string :item
      t.string :comment
      t.float :price
      t.date :expended_at

      t.timestamps
    end
  end
end
