require File.dirname(__FILE__) + '/../test_helper'

class RegistrationTest < ActiveSupport::TestCase
  test "should have many courses" do
    @registration = Registration.generate
    assert_equal 2, @registration.courses.length
  end

  test "should not create withoud required fields" do
    @registration = Registration.new
    assert !@registration.valid?
    assert_equal 1, @registration.errors[:name].length
    assert_equal 2, @registration.errors[:email].length
    assert_equal 1, @registration.errors[:phone1].length
    assert_equal 1, @registration.errors[:courses].length

    @registration.attributes = { :name => "Saulo Arruda", :email => "saulo@jera.com.br", :phone1 => "(67) 3043-0248", 
      :courses => [ @registration.courses.build(:course => Factory.create(:course)) ] }
    assert @registration.valid?
  end
  
  test "should calculate total" do
    @registration = Registration.generate
    assert_equal 600, @registration.total
  end

  test "should notify payment" do
    @registration = Registration.generate
    assert @registration.pay 
    assert @registration.payed
  end

  test "should cancel duplicate registrations" do
    registration1 = Registration.generate
    registration2 = Registration.generate(:email => registration1.email)
    assert registration1.reload.cancelled
  end

  test "should undo cancellation on payment" do
    registration1 = Registration.generate
    registration2 = Registration.generate(:email => registration1.email)
    registration1.cancel
    assert registration1.reload.cancelled
    assert !registration2.reload.cancelled
    registration1.pay
    assert !registration1.reload.cancelled
    assert registration2.reload.cancelled
  end
end