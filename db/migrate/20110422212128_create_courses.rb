class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.references  :instructor
      t.string      :name, :null => false
      t.string      :date
      t.float       :price, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
