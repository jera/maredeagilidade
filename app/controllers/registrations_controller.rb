class RegistrationsController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :find_registration, :only => [:show, :edit, :update, :destroy]
  before_filter :filter_registrations, :only => [:index, :filter, :send_email]
  helper :all

  def authenticate
    unless session[:instructor]
      redirect_to login_path
    end
  end

  def filter
    render :action => :index
  end
  
  def send_email
    render :status => :forbidden and return unless admin? 
    @registrations.each do |registration|
      RegistrationMailer.send_custom(registration, params[:email_text]).deliver
    end
    flash[:success] = t('sended', :count => @registrations.size)
    render :action => :index
  end

  def filter_registrations
    @registrations = Registration.search(params.merge({:instructor => session[:instructor]}), admin?)
  end

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(params[:registration])
    params[:courses].each do |course_id|
      course = Course.find(course_id)
      raise t('registration.end') if course.registration_end < Date.today
      @registration.courses.build(:course_id => course_id)
    end if params[:courses]
    if @registration.save
      redirect_to registration_path(@registration) + '?token=' + get_token(@registration)
    else
      render :new
    end
  end

  def update
    respond_to do |f|
      if @registration.update_attributes(params[:registration])
        flash[:success] = t('saved')
        f.json { render :json => :ok }
        f.html { redirect_to root_path }
      else
        logger.warn @registration.errors.inspect
        f.json { render :json => @registration.errors }
        f.html { render :edit }
      end
    end
  end

  def show
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
  
  def destroy
    @registration.cancel
    render :json => :ok
  end
  
  def find_registration
    @registration = Registration.find(params[:id])
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
