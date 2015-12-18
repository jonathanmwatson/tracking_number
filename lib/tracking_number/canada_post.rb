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
    LENGTH = 16 

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
    SEARCH_PATTERN = /(([A-Z]\s*){2}([0-9]\s*){9}([A-Z]\s*){2})/
    VERIFY_PATTERN = /([A-Z]{2})([0-9]{8})([0-9]{1})([A-Z]{2})/
    LENGTH = 13

    def matches
      self.tracking_number.scan(VERIFY_PATTERN).flatten
    end


    def valid_checksum?
      prefix, digits, check_digit, country = matches

      chars = digits.chars.to_a

      sum = 0
      chars.zip([8,6,4,2,3,5,9,7]).each do |pair|
        sum += (pair[0].to_i * pair[1].to_i)
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
  end
end
