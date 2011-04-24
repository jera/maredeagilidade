class RegistrationCourse < ActiveRecord::Base
  belongs_to :registration
  belongs_to :course
end
