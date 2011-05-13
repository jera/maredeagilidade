class Registration < ActiveRecord::Base
  has_many :courses, :class_name => 'RegistrationCourse', :foreign_key => :registration_id
  validates_presence_of :name, :phone1, :courses, :tshirt_size
  validates_presence_of :document_number, :on => :create
  validates_presence_of :company_name, :if => "self.person_type=='J'", :on => :create
  validates :email, :presence => true, :email => true
  attr_accessor :person_type

  after_create :check_duplication, 'RegistrationMailer.send_new(self).deliver'
  after_save :send_payed_email
  after_validation :check_payed
  
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