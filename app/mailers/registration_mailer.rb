class RegistrationMailer < ActionMailer::Base
  default :from => "eventos@jera.com.br"

  def send_new(registration)
    configure(registration)
  end

  def send_pay(registration)
    configure(registration)
  end
  
  private 
    def configure(registration)
      @registration = registration
      mail :to => "#{registration.name} <#{registration.email}>"
    end
end
