# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    Spotippos::Property.clean_all
  end
end
