require 'rubygems'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'spork'
require 'factory_girl/syntax/generate'

Spork.prefork do 
end

Spork.each_run do
end

class ActiveSupport::TestCase
end
