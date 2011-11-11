module NumberConverter
  class Converter
    attr_reader :original_base, :original_number

    @@supported_bases = [2,10,16]

    class << self
      def supported_bases
        return @@supported_bases
      end
    end

    def initialize(number, original_base = nil)
      unless number.class == String
        raise TypeError, "The first argument should be of class String."
      end

      unless original_base.nil?
        # FIXME: to_i called two times below!
        if @@supported_bases.include? original_base.to_i
          @original_base = original_base.to_i
        else
          raise RangeError, "#{original_base} is not a valid base."
        end
      end

      if original_base.nil?
        detect_base(number)
      else
        unless verify_base(number, original_base)
          raise ArgumentError, "Invalid number/base combination."
        end
      end

      @original_number = number
    end

    def to_binary
      convert @original_number, @original_base, 2
    end

    def to_decimal
      convert @original_number, @original_base, 10
    end

    def to_hex
      convert @original_number, @original_base, 16
    end

    private

    def convert(number, from_base, to_base)
      number.to_i(from_base).to_s(to_base).upcase
    end

    def detect_base(number)
      if number =~ /^[01]+$/
        @original_base = 2
      elsif number =~ /^[0-9]+$/
        @original_base = 10
      elsif number =~ /^[0-9a-fA-F]+$/
        @original_base = 16
      elsif number =~ /[^0-9a-fA-F]$/
        raise ArgumentError, "You submitted an invalid number"
      end
    end

    def verify_base(number, submitted_base)
      # FIXME: Refactor that fucking method!
      if submitted_base == "2"
        if number =~ /^[01]+$/
          return true
        else
          return false
        end
      elsif submitted_base == "10"
        if number =~ /^[0-9]+$/
          return true
        else
          return false
        end
      elsif submitted_base == "16"
        if number =~ /^[0-9a-fA-F]+$/
          return true
        else
          return false
        end
      end
    end
  end
end
