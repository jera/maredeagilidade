class Registration < ActiveRecord::Base
  has_many :courses, :class_name => 'RegistrationCourse', :foreign_key => :registration_id
  validates_presence_of :name, :phone1, :courses, :tshirt_size
  validates_presence_of :document_number, :on => :create
  validates_presence_of :company_name, :if => "self.person_type=='J'", :on => :create
  validates :email, :presence => true, :email => true
  attr_accessor :person_type

  after_create :check_duplication, 'RegistrationMailer.send_new(self).deliver'
  after_save :send_payed_email, :if => '!checkin_changed? && !winning_changed?'
  after_validation :check_payed
  
  scope :checked_in, where('checkin is not null and cancelled = false')
  scope :for_raffle, checked_in.where(:winning => false)

  def person_type
    @person_type ||= (self.company_name.nil? || self.company_name.blank?) ? 'F' : 'J'
  end

  def pay
    self.status = 1
    self.cancelled = false
    save!
    check_duplication
  end
  
  def payed
    self.status > 0
  end
  
  def total
    unless @total
      @total = 0
      self.courses.each do |registration_course|
        @total += registration_course.course.price
      end
    end
    @total
  end
  
  def cancel
    self.cancelled = true
    save!
  end
  
  def free_courses?
    self.courses.each do |registration_course|
      return false if registration_course.course.free?
    end
    true
  end

  def self.search(params, order_by,admin)
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
      and_where << "checkin is not null" unless params[:checked_in].nil?
      or_where << "(status=0 AND cancelled=1)" if !params[:cancelled].nil?
    end
    if or_where.empty?
      or_where << "status>0 OR (status=0 AND cancelled=0)"
    end

    if admin
      Registration.joins(:courses => [:course]).where("#{and_where.join(' AND ')} AND (#{or_where.join(' OR ')})").order("registrations.#{order_by}").group(:registration_id)
    else
      Registration.joins(:courses => [:course]).where('courses.instructor_id' => params[:instructor], :cancelled => false).where("#{and_where.join(' AND ')} AND (#{or_where.join(' OR ')})").order('registrations.created_at DESC').group(:registration_id)
    end
  end
  
  
  def generate_certificate
    img = Rails.root.join('public/images/certificate.png')
    pdf = Prawn::Document.new(:page_size => 'A4', :page_layout => :landscape, :background => img)
    pdf.font_size = 32
    pdf.text(self.name,:valign=> :center, :align => :center)
    return pdf
  end
  
  private
    def send_payed_email
      RegistrationMailer.send_pay(self).deliver if self.status > 0
    end
  
    def check_duplication
      duplications = Registration.where(:email => self.email, :cancelled => false, :status => 0).order(:created_at)
      duplications.each do |duplication|
        duplication.cancel if duplication.id != self.id
      end
    end
    
    def check_payed 
      self.cancelled = false if self.payed
    end
end
