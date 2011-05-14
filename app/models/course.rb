class Course < ActiveRecord::Base
  belongs_to :instructor
  
  # if don't have a instructor, this course enrolment is for free if registration includes another course
  def free?
    self.instructor.nil?
  end
  
  def can_register
    if self.registration_end.nil?
      true
    else
      self.registration_end < Date.today
    end
  end
  
  def pagseguro_price
    self.price
    # desabilitei parcelamento sem acréscimo @sauloarruda
    # (self.price >= 300.0) ? (self.price * 1.0708) : self.price
  end
end
