module RegistrationHelper

  def experience_options
    experiences
  end
  
  def experience_s(value)
    experiences[value][0]
  end
  
  def experiences
    [ 
      [t('select'), 0], 
      [t('experience_options.newbie'), 1], 
      [t('experience_options.praticant'), 2], 
      [t('experience_options.expert'), 3]
    ]
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

end
