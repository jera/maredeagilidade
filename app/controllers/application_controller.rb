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
end
