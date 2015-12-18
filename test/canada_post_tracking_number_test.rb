require 'test_helper'

class CanadaPostTrackingNumberTest < Minitest::Test
  context "a Canada Post tracking number" do
    ["7313411015997238", "1016806952987141", "4001313323312291" ].each do |valid_number|
      should "return Canada Post with valid 16 digit number: #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::CanadaPost16, :canadapost)
      end

      should "detect #{valid_number} regardless of spacing" do
        should_detect_number_variants(valid_number, TrackingNumber::CanadaPost16)
      end
    end
  end

  context "a Canada Post tracking number" do
    ["LM047801962CA" ].each do |valid_number|
      should "return Canada Post with valid 13 character tracking number: #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::CanadaPost13, :canadapost)
      end

      should "detect #{valid_number} regardless of spacing" do
        should_detect_number_variants(valid_number, TrackingNumber::CanadaPost13)
      end
    end
  end

end
