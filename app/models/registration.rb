class Registration < ActiveRecord::Base
  has_many :courses, :class_name => 'RegistrationCourse', :foreign_key => :registration_id
  validates_presence_of :name, :phone1, :courses
  validates :email, :presence => true, :email => true
  
  def pay
    self.payed = true
    save!
  end
end