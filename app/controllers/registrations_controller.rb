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
      @registrations = Registration.joins(:courses => [:course]).where('courses.instructor_id' => instructor, :cancelled => false).order('updated_at DESC').group(:registration_id)
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
      redirect_to registration_path(@registration) + '?token=' + get_token(@registration)
    else
      render :new
    end
  end
  
  def show
    @registration = Registration.find(params[:id])
    if params[:token] != get_token(@registration) 
      render :file => "public/422.html", :status => :unauthorized
      return
    end
    unless @registration.payed
      @order = PagSeguro::Order.new(@registration.id)
      @registration.courses.each do |registration_course|
        course = registration_course.course
        @order.add :id => course.id, :price => course.pagseguro_price, :description => course.name
      end
      #@order.shipping_type = "FR"
      @order.billing = {
        :name                  => @registration.name,
        :email                 => @registration.email,
        :phone_area_code       => "67",
        :phone_number          => @registration.phone1,
        :address_zipcode       => "79002401",
        :address_street        => "Rua Jose Antonio Pereira",
        :address_number        => 1397,
        :address_complement    => "sala 1",
        :address_neighbourhood => "Centro",
        :address_city          => "Campo Grande",
        :address_state         => "MS",
        :address_country       => "Brasil"
      }
    end
  end
  
  skip_before_filter :verify_authenticity_token, :only => :pay

  def pay 
    if request.post?
      pagseguro_notification do |notification|
        logger.info "status=#{notification.status}, id=#{notification.order_id}, payment_method=#{notification.payment_method}, processed_at=#{notification.processed_at}, transaction_id=#{notification.transaction_id}, notes=#{notification.notes}"
        if notification.status == :approved || notification.status == :completed
          @registration = Registration.find(notification.order_id)
          logger.error('registration not found '+ notification.order_id) unless @registration 
          @registration.pay
        end
      end
      render :nothing => true
    else
      render :done
    end
  end

end
