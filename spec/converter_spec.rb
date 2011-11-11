require_relative "./spec_helper"

describe "Converter" do
  it "should provide to the user a list of supported bases" do
    NumberConverter::Converter.must_respond_to :supported_bases
    NumberConverter::Converter.supported_bases.must_be_instance_of Hash
  end

  describe "original number" do
    it "should be required" do
      lambda do
        NumberConverter::Converter.new
      end.must_raise ArgumentError
    end

    it "should be of class String" do
      different_types = [42,true,42.0,42...73]
      different_types.each do |type|
        lambda do
          NumberConverter::Converter.new(type)
        end.must_raise TypeError
      end

      correct_type = "42"
      lambda do
        NumberConverter::Converter.new(correct_type)
      end.must_be_silent
    end

    it "should be stored" do
      converter = NumberConverter::Converter.new("101010")
      converter.must_respond_to :original_number
      converter.original_number.must_equal "101010"
    end
  end

  describe "original base" do
    it "should give the option to specify the original base" do
      lambda do
        NumberConverter::Converter.new("101010", 2)
      end.must_be_silent

      lambda do
        NumberConverter::Converter.new("101010", 10)
      end.must_be_silent

      lambda do
        NumberConverter::Converter.new("101010", 16)
      end.must_be_silent
    end

    it "should only accept the supported bases for the original base" do
      lambda do
        NumberConverter::Converter.new("101010", 42)
      end.must_raise RangeError
    end

    it "should store the original base" do
      NumberConverter::Converter.new("101010").must_respond_to :original_base
    end
  end

  describe "base detection" do
    it "should only try to detect the type if the second argument was not passed" do
      converter = NumberConverter::Converter.new("101010", 10).original_base.must_equal 10
    end

    it "should detect the base of the argument" do
      converter = NumberConverter::Converter.new("101010")
      converter.original_base.must_equal 2

      converter = NumberConverter::Converter.new("42")
      converter.original_base.must_equal 10

      converter = NumberConverter::Converter.new("2A")
      converter.original_base.must_equal 16
    end
  end

  describe "binary numbers" do
    it "should convert binary numbers to decimal" do
      converter = NumberConverter::Converter.new("101010")
      converter.to_decimal.must_equal "42"
    end

    it "should convert binary numbers to hexadecimal" do
      converter = NumberConverter::Converter.new("101010")
      converter.to_hex.upcase.must_equal "2A"
    end
  end

  describe "decimal numbers" do
    it "should convert decimal numbers to binary" do
      converter = NumberConverter::Converter.new("42")
      converter.to_binary.must_equal "101010"
    end

    it "should convert decimal numbers to hexadecimal" do
      converter = NumberConverter::Converter.new("42")
      converter.to_hex.must_equal "2A"
    end
  end

  describe "hexadecimal numbers" do
    it "should convert hexadecimal numbers to binary" do
      converter = NumberConverter::Converter.new("2a")
      converter.to_binary.must_equal "101010"
    end

    it "should convert hexadecimal numbers to decimal" do
      converter = NumberConverter::Converter.new("2a")
      converter.to_decimal.must_equal "42"
    end
  end

  describe "invalid numbers" do
    it "should reject invalid numbers" do
      lambda do
        converter = NumberConverter::Converter.new("forty-two")
      end.must_raise ArgumentError
    end
  end
end
