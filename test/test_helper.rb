require 'rubygems'

ENV["RAILS_ENV"] = "test"
require 'factory_girl'
require File.expand_path('../../config/environment', __FILE__)
require File.expand_path('../factories', __FILE__)
require 'factory_girl/syntax/generate'
require 'rails/test_help'
require 'spork'

Spork.prefork do 
end

Spork.each_run do
end

class ActiveSupport::TestCase
end
