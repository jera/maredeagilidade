class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
    def get_token(obj)
      Digest::MD5.hexdigest(CONFIG['security_salt'] + @registration.id.to_s)
    end
end
