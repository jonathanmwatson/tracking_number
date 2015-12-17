module TrackingNumber
  class CanadaPost < Base
    def carrier
      :canadapost
    end

    def is_mod11?(sequence, check_digit)

      sum = 0
      sequence.to_s.reverse.chars.each_with_index do |char, i|
        sum += char.to_i * i.to_i
      end

      remainder = sum % 11

      check = case remainder
      when 1
        0
      when 0
        5
      else
        11 - remainder
      end

      return check == check_digit.to_i
    end

    def is_mod10?(value, check_digit)
      total = 0
      value.chars.to_a.reverse.each_with_index do |c, i|
        x = c.to_i
        x *= 3 if i.even?
        total += x
      end

      check = total % 10
      check = 10 - check unless (check.zero?)
      return check == check_digit.to_i
    end
  end

  class CanadaPost16 < CanadaPost
    SEARCH_PATTERN = /(([0-9]\s*){16,16})/
    VERIFY_PATTERN = /([0-9]{15,15})([0-9]{1})/

    def matches
      self.tracking_number.scan(VERIFY_PATTERN).flatten
    end

    def valid_checksum?
      sequence, check_digit = matches

      return true if is_mod11?(sequence, check_digit)

      #try the sliced sequence
      digits = sequence.slice(7...15)
      return true if is_mod10?(sequence, check_digit)
    end

  end

  class CanadaPost13 < CanadaPost
    SEARCH_PATTERN = /^(([A-Z]){2,2}([0-9]\s*){9,9}([A-Z]){2,2})/
    VERIFY_PATTERN = /^([A-Z]{2,2})([0-9]{8,8})([0-9]{1})([A-Z]{2})$/

    def valid_checksum?
      puts "der"
      puts decode
    end

    def decode
      puts "her"
      {:prefix => self.tracking_number.to_s.slice(0...2),
       :serial_number =>  self.tracking_number.to_s.slice(2...9),
       :check_digit => self.tracking_number.to_s.slice(9...10),
       :country_code =>  self.tracking_number.to_s.slice(11...13),
       :check_digit => self.tracking_number.slice(21...22)
      }
    end
  end

end
