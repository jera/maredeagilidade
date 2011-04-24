require File.dirname(__FILE__) + '/../test_helper'

class RegistrationCourseTest < ActiveSupport::TestCase

  def setup
    @registration_course = Registration.generate.courses[0]
  end

  test "should belongs to course" do
    assert_not_nil @registration_course.course
  end

  test "should belongs to registration" do
    assert_not_nil @registration_course.registration
  end
end
