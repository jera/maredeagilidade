class RegistrationsController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :find_registration, :only => [:show, :edit, :update, :destroy]

  def authenticate
    unless session[:instructor]
      redirect_to login_path
    end
  end

  def index
    or_where = []
    and_where = ['1=1']
    if params[:commit]
      # courses
      and_where << "registration_courses.course_id=#{params[:course]}" unless params[:course].blank?
      
      # name
      and_where << "registrations.name LIKE '%#{params[:text]}%' OR registrations.email LIKE '%#{params[:text]}%'" unless params[:text].blank?
      
      # status
      params[:status].each do |status|
        or_where << "(status=#{status})"
      end
      
      # cancelled
      and_where << "cancelled=0" if params[:cancelled].nil?
      or_where << "(status=0 AND cancelled=1)" if !params[:cancelled].nil?
    end
    
    
    if or_where.empty?
      or_where << "status>0 OR (status=0 AND cancelled=0)"
    end
    logger.debug and_where
    logger.debug or_where
    if admin?
      @registrations = Registration.joins(:courses => [:course]).where("#{and_where.join(' AND ')} AND (#{or_where.join(' OR ')})").order('registrations.created_at DESC').group(:registration_id)
    else
      @registrations = Registration.joins(:courses => [:course]).where('courses.instructor_id' => session[:instructor], :cancelled => false).where("#{and_where.join(' AND ')} AND (#{or_where.join(' OR ')})").order('registrations.created_at DESC').group(:registration_id)
    end
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
