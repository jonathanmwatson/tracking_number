require 'test_helper'

class ChinaPostTrackingNumberTest < Minitest::Test
  context "a China Post tracking number" do
    ["RS273138601CN", "LS386578255CN", "RS273138701CN" ].each do |valid_number|
      should "return China Post with valid 13 digit number: #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::ChinaPostAirMail, :chinapost)
      end

      should "detect #{valid_number} regardless of spacing" do
        should_detect_number_variants(valid_number, TrackingNumber::ChinaPostAirMail)
      end
    end
  end

end
