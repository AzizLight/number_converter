module NumberConverter
  class Converter
    attr_reader :original_base, :original_number

    @@supported_bases = [2,10,16]

    def initialize(number, original_base = nil)
      unless number.class == String
        raise TypeError, "The first argument should be of class String."
      end

      unless original_base.nil?
        if @@supported_bases.include? original_base
          @original_base = original_base
        else
          raise RangeError, "#{original_base} is not a valid base."
        end
      end

      detect_base(number) if original_base.nil?

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
      end
    end
  end
end
