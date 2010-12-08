class AddSpToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :service_provider, :string
  end

  def self.down
    remove_column :users, :service_provider
  end
end
