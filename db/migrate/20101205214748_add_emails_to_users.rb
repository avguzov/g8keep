class AddEmailsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :personal_email, :string
    add_column :users, :work_email, :string
  end

  def self.down
    remove_column :users, :work_email
    remove_column :users, :personal_email
  end
end
