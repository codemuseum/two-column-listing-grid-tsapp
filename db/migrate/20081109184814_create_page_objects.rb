class CreatePageObjects < ActiveRecord::Migration
  def self.up
    create_table :page_objects do |t|
      t.string :urn
      t.string :header
      t.string :data_path
      t.text :left_listings
      t.text :right_listings

      t.timestamps
    end
  end

  def self.down
    drop_table :page_objects
  end
end
