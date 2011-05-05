# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110504145211) do

  create_table "courses", :force => true do |t|
    t.integer  "instructor_id"
    t.string   "name",          :null => false
    t.string   "date"
    t.float    "price",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instructors", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "company",    :null => false
    t.string   "username",   :null => false
    t.string   "password",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registration_courses", :force => true do |t|
    t.integer  "registration_id", :null => false
    t.integer  "course_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", :force => true do |t|
    t.string   "email",                                           :null => false
    t.string   "name",                                            :null => false
    t.string   "twitter"
    t.string   "website"
    t.integer  "experience"
    t.string   "phone1",                                          :null => false
    t.string   "phone2"
    t.string   "tshirt_size",     :limit => 2,                    :null => false
    t.boolean  "payed",                        :default => false, :null => false
    t.boolean  "cancelled",                    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name"
    t.string   "document_number"
  end

end
