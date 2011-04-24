class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.string    :email, :null => false, :unique => true
      t.string    :name, :null => false
      t.string    :twitter
      t.string    :website
      t.integer   :experience
      t.string    :phone1, :null => false
      t.string    :phone2
      t.timestamps
    end
  end

  def self.down
    drop_table :registrations
  end
end
