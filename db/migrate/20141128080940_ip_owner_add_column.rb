class IpOwnerAddColumn < ActiveRecord::Migration
  def change
  	add_column :ip_owners, :reason, :string
  end
end
