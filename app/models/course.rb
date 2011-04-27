class Course < ActiveRecord::Base
  belongs_to :instructor
  
  # if don't have a instructor, this course enrolment is for free if registration includes another course
  def free?
    self.instructor.nil?
  end
  
  def pagseguro_price
    (self.price >= 300.0) ? (self.price * 1.0708) : self.price
  end
end
