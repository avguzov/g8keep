class AddPhonesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :home_phone, :string
    add_column :users, :work_phone, :string
    add_column :users, :cell_phone, :string
  end

  def self.down
    remove_column :users, :cell_phone
    remove_column :users, :work_phone
    remove_column :users, :home_phone
  end
end
