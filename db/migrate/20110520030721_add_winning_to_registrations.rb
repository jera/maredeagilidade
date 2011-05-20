class AddWinningToRegistrations < ActiveRecord::Migration
  def self.up
    add_column(:registrations, :winning, :boolean, :null => false, :default => false)
  end

  def self.down
    remove_column(:registrations, :winning)
  end
end
