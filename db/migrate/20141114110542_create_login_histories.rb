class CreateLoginHistories < ActiveRecord::Migration
  def change
    create_table :login_histories, :id => false do |t|
      t.string :ip
      t.string :path
      t.text :agent
      t.datetime :created_at
    end
  end
end
