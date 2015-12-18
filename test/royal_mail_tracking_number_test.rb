require 'test_helper'

class RoyalMailTrackingNumberTest < Minitest::Test
  context "a Royal Mail tracking number" do
    ["", "", "" ].each do |valid_number|
      should "return Royal Mail with valid 16 digit number: #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::CanadaPost16, :canadapost)
      end

      should "detect #{valid_number} regardless of spacing" do
        should_detect_number_variants(valid_number, TrackingNumber::CanadaPost16)
      end
    end
  end

end
