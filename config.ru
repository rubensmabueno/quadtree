require File.expand_path('../config/environment', __FILE__)

use OTR::ActiveRecord::ConnectionManagement

run Spotippos::API.new
