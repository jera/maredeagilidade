class CreateRegistrationCourses < ActiveRecord::Migration
  def self.up
    create_table :registration_courses do |t|
      t.references  :registration, :null => false
      t.references  :course, :null => false
      t.boolean     :payed, :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :registration_courses
  end
end
