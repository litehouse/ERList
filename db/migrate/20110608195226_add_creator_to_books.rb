class AddCreatorToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :creator_id, :integer
    add_index :books, :creator_id
  end
  

  def self.down
    remove_column :books, :creator_id
  end
end
