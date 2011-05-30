class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  helper_method :admin?

  protected
    def get_token(obj)
      Digest::MD5.hexdigest(CONFIG['security_salt'] + @registration.id.to_s)
    end
    
    def admin?
      session[:instructor] == -1
    end
    
  def render_to_pdf(options = nil)
    data = render_to_string(options)
    pdf = PDF::HTMLDoc.new
    pdf.set_option :bodycolor, :white
    pdf.set_option :toc, false
    pdf.set_option :landscape, true
    pdf.set_option :links, false
    pdf.set_option :webpage, true
    pdf.set_option :left, '2cm'
    pdf.set_option :right, '2cm'
    pdf << data
    pdf.generate
  end
end
