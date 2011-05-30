module RegistrationHelper

  def experience_options
    experiences
  end
  
  def experience_s(value)
    experiences[value][0]
  end
  
  def courses_options
    [[t('all_courses'), '']] + Course.all.collect { |c| [ c.name, c.id ] }
  end
  
  def experiences
    [ 
      [t('select'), 0], 
      [t('experience_options.newbie'), 1], 
      [t('experience_options.praticant'), 2], 
      [t('experience_options.expert'), 3]
    ]
  end
  
  def tshirt_size_options
   [ 
      [t('select'), ''], 
      ['PP'],
      ['P' ], 
      ['M' ], 
      ['G' ],
      ['GG'],
      ['XG']
    ]
  end
  
  def is_status_checked(status, params)
    if params['commit'].nil?
      true
    else
      !params["status"].index(status.to_s).nil?
    end
  end
  
  def status_options
    options = []
    0.upto(4) {|n| options << [ t("status_#{n}"), n ]}
    options
  end

  def choose_course(registration, course_id)
    registration.courses.each do |course|
      return true if course.course_id == course_id
    end
    false
  end

  def courses_s(courses)
    courses.collect {|c| c.course.name }.join(', ')
  end

  def registration_end_notification(course)
    return '' if course.registration_end.nil? 
    message = nil
    if course.registration_end > Date.today
      message = t('registration.last_days', :date => l(course.registration_end, :format => :short)) if course.registration_end-3.days < Date.today
    elsif course.registration_end == Date.today
      message = t('registration.last_day')
    elsif course.registration_end < Date.today
      message = t('registration.end')
    end
    content_tag :label, message, :class => 'registration_end' unless message.nil?
  end
  
end
