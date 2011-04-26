class RegistrationsController < ApplicationController
  before_filter :authenticate, :only => :index

  def authenticate
    unless session[:instructor]
      redirect_to login_path
    end
  end

  def index
    instructor = (session[:instructor] > 0) ? session[:instructor] : nil
    if instructor
      @registrations = Registration.joins(:courses => [:course]).where('courses.instructor_id' => instructor).order('updated_at DESC').group(:registration_id)
    else
      @registrations = Registration.joins(:courses => [:course]).order('updated_at DESC').group(:registration_id)
    end
  end

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(params[:registration])
    params[:courses].each do |course_id|
      @registration.courses.build(:course_id => course_id)
    end if params[:courses]
    if @registration.save
      redirect_to registration_path(@registration)
    else
      render :index
    end
  end
  
  def show
    @registration = Registration.find(params[:id])
    unless @registration.payed
      @order = PagSeguro::Order.new(@registration.id)
      @registration.courses.each do |registration_course|
        course = registration_course.course
        @order.add :id => course.id, :price => course.price, :description => course.name
      end
      @order.shipping_type = "FR"
      @order.billing = {
        :name         => @registration.name,
        :email        => @registration.email,
        :phone_number => @registration.phone1
      }
    end
  end
  
  skip_before_filter :verify_authenticity_token, :only => :pay

  def pay 
    if request.post?
      pagseguro_notification do |notification|
        logger.info notification.inspect
        if notification.status == 'approved'
          @registration = Registration.find(notification.referencia)
          logger.error('registration not found '+ notification.referencia) unless @registration 
          @registration.pay
        end
      end
      render :nothing => true
    else
      render :done
    end
  end

end
