class AddRegistrationStatus < ActiveRecord::Migration
  def self.up
    add_column(:registrations, :status, :integer, :nullable => false, :default => 0)
    puts 'updating status with payed column value'
    Registration.all.each do |r|
       r.status = (r.payed) ? 1 : 0
       r.save
    end
    remove_column(:registrations, :payed)
  end

  def self.down
    remove_column(:registrations, :status)
    add_column(:registrations, :payed, :boolean)
  end
end
