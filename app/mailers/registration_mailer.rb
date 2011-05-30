class RegistrationMailer < ActionMailer::Base
  default :from => "eventos@jera.com.br"

  def send_new(registration)
    configure(registration)
  end

  def send_pay(registration)
    configure(registration)
  end

  def send_custom(registration, subject, message)
    @message = message
    configure(registration, subject)
  end
  
  def send_certificate(registration)
    pdf = registration.generate_certificate
    attachments["#{I18n.t('certificate')}.pdf"] = pdf.render
    configure(registration,I18n.t('certificate-mail-subject'))
  end

  
  private 
    def configure(registration, subject = nil)
      @registration = registration
      options = { :to => "#{registration.name} <#{registration.email}>" }
      options[:subject] = subject if subject
      logger.debug options.inspect
      mail options
    end
end
