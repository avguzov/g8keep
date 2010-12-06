class AddAcceptedToRelationships < ActiveRecord::Migration
  def self.up
    add_column :relationships, :accepted, :boolean, :default => false
  end

  def self.down
    remove_column :relationships, :accepted
  end
end
