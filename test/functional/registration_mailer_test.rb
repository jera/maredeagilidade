require File.dirname(__FILE__) + '/../test_helper'

class RegistrationMailerTest < ActionMailer::TestCase
  test "send new registration email" do
    @registration = Registration.generate
    mail = RegistrationMailer.send_new(@registration).deliver
    puts mail.encoded
    assert !ActionMailer::Base.deliveries.empty?
    assert_match @registration.name, mail.body.encoded
  end

  test "send paymento confirmation email" do
    @registration = Registration.generate
    mail = RegistrationMailer.send_pay(@registration).deliver
    puts mail.encoded
    assert !ActionMailer::Base.deliveries.empty?
    assert_match @registration.name, mail.body.encoded
  end

end
