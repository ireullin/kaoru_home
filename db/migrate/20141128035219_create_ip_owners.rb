class CreateIpOwners < ActiveRecord::Migration
  def change
    create_table :ip_owners do |t|
      t.string :ip
      t.string :name

      t.timestamps
    end

    add_index :ip_owners, :ip, :unique => true

  end
end
