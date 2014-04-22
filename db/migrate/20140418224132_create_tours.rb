class CreateTours < ActiveRecord::Migration
  def self.up
    create_table :tours do |t|
      t.integer :id
      t.string :uuid
      t.integer :state
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.date :date
      t.string :location
      t.string :amenities
      t.timestamps
    end
  end

  def self.down
    drop_table :tours
  end
end
