class Registration < ActiveRecord::Base
  has_many :courses, :class_name => 'RegistrationCourse', :foreign_key => :registration_id
  validates_presence_of :name, :phone1, :courses
  validates :email, :presence => true, :email => true

  after_create :check_duplication

  def pay
    self.payed = true
    self.cancelled = false
    save!
    check_duplication
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
  
  private
    def check_duplication
      duplications = Registration.where(:email => self.email, :cancelled => false, :payed => false).order(:created_at)
      duplications.each do |duplication|
        duplication.cancel if duplication.id != self.id
      end
    end
end