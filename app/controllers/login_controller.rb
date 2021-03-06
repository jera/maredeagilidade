class LoginController < ApplicationController

  def index
    if request.post?
      if params[:username] == 'admin'
        if admin_password == params[:password]
          session[:instructor] = -1
          redirect_to root_path
          return
        end
      else
        instructor = Instructor.where(:username => params[:username], :password => params[:password]).first
        if instructor
          session[:instructor] = instructor.id
          redirect_to root_path
          return
        end
      end
      flash[:error] = t('login_error')
    end
  end

  def destroy
    session[:instructor] = nil
    redirect_to login_path
  end
  
  private 
  
    def admin_password
      CONFIG['admin_password']
    end

end
