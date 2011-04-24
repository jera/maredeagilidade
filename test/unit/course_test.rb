require File.dirname(__FILE__) + '/../test_helper'

class CourseTest < ActiveSupport::TestCase
  test "should belongs to instructor" do
    @instructor = Factory.create(:instructor)
    @course = Factory.create(:course, :instructor => @instructor)
    assert_equal @instructor, @course.instructor
  end
end
