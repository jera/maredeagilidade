Factory.define :instructor do |t|
  t.sequence(:name) {|n| "instructor#{n}"}
  t.sequence(:company) {|n| "company#{n}"}
  t.sequence(:username) {|n| "username#{n}"}
  t.password        'secret'
end
  
Factory.define :course do |t|
  t.association     :instructor
  t.sequence(:name) {|n| "course#{n}"}
  t.date            '20 a 22 de maio'
  t.price           300.00
end

Factory.define :registration do |t|
  t.sequence(:email)  {|n| "registration#{n}@gmail.com"}
  t.sequence(:name)   {|n| "name#{n}"}
  t.phone1            '(67) 3043-0248'
  t.courses do |registration|
    courses = []
    2.times { courses << Factory.build(:registration_course, :registration => registration.result) }
    courses
  end
end

Factory.define :registration_course do |t|
  t.association :registration
  t.association :course
end