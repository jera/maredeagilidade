module RegistrationHelper

  def experience_options
    [ t('experience_options.newbie'), t('experience_options.praticant'), t('experience_options.expert') ]
  end

  def choose_course(registration, course_id)
    registration.courses.each do |course|
      return true if course.course_id == course_id
    end
    false
  end

end
