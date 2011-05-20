class AddCheckinToRegistration < ActiveRecord::Migration
  def self.up
    add_column(:registrations, :checkin, :datetime)
  end

  def self.down
    remove_column(:registrations, :checkin)
  end
end
