class AddCourseRegistrationEndDate < ActiveRecord::Migration
  def self.up
    add_column(:courses, :registration_end, :date)
  end

  def self.down
    remove_column(:courses, :registration_end)
  end
end
