class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :accessor_id
      t.integer :accessed_id

      t.timestamps
    end
	add_index :relationships, :accessor_id
	add_index :relationships, :accessed_id
  end

  def self.down
    drop_table :relationships
  end
end
