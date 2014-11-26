class CreateMoneyNoteItems < ActiveRecord::Migration
  def change
    create_table :money_note_items, :id => false do |t|
      t.text :items
      t.datetime :updated_at
    end
  end
end
