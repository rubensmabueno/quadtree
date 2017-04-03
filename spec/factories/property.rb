# frozen_string_literal: true
FactoryGirl.define do
  factory :property, class: Spotippos::Property do
    x 10
    y 10
    title 'Property'
    price 3000
    description 'Brief description'
    beds 3
    baths 2
    square_meters 65
  end
end
