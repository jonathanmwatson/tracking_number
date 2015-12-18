module TrackingNumber
  class ChinaPost < Base
    def carrier
      :chinapost
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

  class ChinaPostAirMail < ChinaPost
    SEARCH_PATTERN = /(([R]\s*){1}([A-Z]\s*){1}([0-9]\s*){9}([CN]\s*){2})/
    VERIFY_PATTERN = /(([R]\s*){1}([A-Z]\s*){1}([0-9]\s*){8}([0-9]\s*){1}([CN]\s*){2})/
    LENGTH = 13

    def matches
      self.tracking_number.scan(VERIFY_PATTERN).flatten
    end


    def valid_checksum?
      prefix, character, sequence, check_digit, country = matches

      return is_mod10?(sequence, check_digit)

    end
  end
end
