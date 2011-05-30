# Load the rails application
require File.expand_path('../application', __FILE__)
Mime::Type.register 'application/pdf', :pdf

# Initialize the rails application
Maredeagilidade::Application.initialize!
