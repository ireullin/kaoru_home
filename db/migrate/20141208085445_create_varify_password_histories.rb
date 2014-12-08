class CreateVarifyPasswordHistories < ActiveRecord::Migration
  def change
    create_table :varify_password_histories do |t|
      t.string :account
      t.string :password
      t.integer :result
      t.string :ip
      t.text :agent

      t.timestamps
    end
  end
end
