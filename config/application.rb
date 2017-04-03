$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

OTR::ActiveRecord.configure_from_file!(File.expand_path('../database.yml', __FILE__))

Dir[File.expand_path('../../app/entities/**/*.rb', __FILE__)].each { |file| require file }
Dir[File.expand_path('../../app/representers/**/*.rb', __FILE__)].each { |file| require file }
Dir[File.expand_path('../../app/resources/**/*.rb', __FILE__)].each { |file| require file }

require 'api'
