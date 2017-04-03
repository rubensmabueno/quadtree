require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'rake'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require File.expand_path('../config/environment', __FILE__)
end

load 'tasks/otr-activerecord.rake'

namespace :db do
  task :environment do
    require File.expand_path('../config/environment', __FILE__)
  end
end

task routes: :environment do
  spotippos::API.routes.each do |route|
    method = route.route_method.ljust(10)
    path   = route.route_path
    puts "     #{method} #{path}"
  end
end
