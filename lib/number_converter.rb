require "sinatra/base"
require "erb"
require "rack-flash"
require "yaml"
require "json"
require "rdiscount"

require_relative "./number_converter/version"
require_relative "./number_converter/converter"

module NumberConverter
  class Application < Sinatra::Base
    use Rack::MethodOverride
    use Rack::Flash

    configure do
      set :root, File.expand_path(File.join(File.dirname(__FILE__), ".."))
      set :app_file, __FILE__

      enable :sessions
      set :session_secret, "nIaRH5Ohk8hfkwmu2r6pQBKVeQDBE9yFlDKVpdWxNTZF0GNgdMFqqN8YkPWLBhQlSP5CDUYLqghyMDIT2kKuI9FYFDehCMHOGY4TuHv4IL2L5mjOYd23RxC3UCHeQGXtz2L8oGaX9O18YFuLsrUSOAlNWXhxXGdIYJeKhRORfzQRs4hj2Jeg3TUKIQR14X8Lvg0c48TK"
    end

    helpers do
      def base_in_english(base)
        #FIXME: The code below should not be hardcoded
        b = ""
        if base == "2"
          b = "binary"
        elsif base == "10"
          b = "decimal"
        elsif base == "16"
          b = "hex"
        end

        return b
      end
    end

    not_found do
      unless request.xhr?
        flash[:error] = "Invalid request."
        redirect "/"
      end
    end

    error do
      unless request.xhr?
        flash[:error] = "Something went wrong"
        redirect "/"
      end
    end

    get "/" do
      erb :main
    end

    post "/" do
      if params[:base].nil? || params[:base].empty?
        redirect "/#{params[:number]}"
      else
        redirect "/#{params[:base]}/#{params[:number]}"
      end
    end

    get "/api" do
      # Display the contents fo README.md in HTML
      if File.exists?("./README.md")
        @docs = RDiscount.new(File.read("./README.md")).to_html

        erb :api
      else
        flash[:error] = "Sorry! The API documentation is not available at the moment."
        redirect "/"
      end
    end

    #
    # GET /:number(.format)
    #
    # number: number to convert
    # format: output format (txt, json, yaml, etc.)
    get /^\/([\da-f]+)(?:\.([a-z]{3,4}))?$/i do |number, format|
      converter = NumberConverter::Converter.new(number)

      @binary  = converter.to_binary
      @decimal = converter.to_decimal
      @hex     = converter.to_hex

      if format.nil?
        if request.xhr?
          erb "ajax/all".to_sym, :layout => false
        else
          erb :main
        end
      else
        numbers_hash = {
          binary: @binary,
          decimal: @decimal,
          hex: @hex
        }

        # Formats
        if format == "txt"
          content_type :txt
          "Binary: #{@binary}\nDecimal: #{@decimal}\nHexadecimal: #{@hex}\n"
        elsif format == "html"
          content_type :html
          html = "<ul>\n" +
            "\t<li><strong>Binary:</strong> #{@binary}</li>\n" +
            "\t<li><strong>Decimal:</strong> #{@decimal}</li>\n" +
            "\t<li><strong>Hexadecimal</strong> #{@hex}</li>\n" +
            "</ul>\n"
          html
        elsif format == "json"
          content_type :json
          numbers_hash.to_json
        elsif format == "yml" || format == "yaml"
          content_type :yaml
          numbers_hash.to_yaml
        elsif format == "csv"
          content_type :csv
          "#{@binary},#{@decimal},#{@hex}\n"
        else
          flash[:error] = "Invalid output format."
          redirect "/"
        end
      end
    end

    #
    # GET /:base/:number(.format)
    #
    # base: input base
    # number: number to convert
    # format: output format (txt, json, yaml, etc.)
    get /^\/(\d+)\/([\da-f]+)(?:\.([a-z]{3,4}))?$/i do |base, number, format|
      if NumberConverter::Converter.supported_bases.include? base.to_i
        begin
          converter = NumberConverter::Converter.new(number, base)
        rescue ArgumentError
          unless request.xhr?
            flash[:error] = "Invalid #{base_in_english(base)} number."
            redirect "/"
          end
        end

        @binary  = converter.to_binary
        @decimal = converter.to_decimal
        @hex     = converter.to_hex

        if format.nil?
          if request.xhr?
            erb "ajax/all".to_sym, :layout => false
          else
            erb :main
          end
        else
          numbers_hash = {
            binary: @binary,
            decimal: @decimal,
            hex: @hex
          }

          # Formats
          if format == "txt"
            content_type :txt
            "Binary: #{@binary}\nDecimal: #{@decimal}\nHexadecimal: #{@hex}\n"
          elsif format == "html"
            content_type :html
            html = "<ul>\n" +
              "\t<li><strong>Binary:</strong> #{@binary}</li>\n" +
              "\t<li><strong>Decimal:</strong> #{@decimal}</li>\n" +
              "\t<li><strong>Hexadecimal</strong> #{@hex}</li>\n" +
            "</ul>\n"
            html
          elsif format == "json"
            content_type :json
            numbers_hash.to_json
          elsif format == "yml" || format == "yaml"
            content_type :yaml
            numbers_hash.to_yaml
          elsif format == "csv"
            content_type :csv
            "#{@binary},#{@decimal},#{@hex}\n"
          else
            flash[:error] = "Invalid output format."
            redirect "/"
          end
        end
      else
        flash[:error] = "Invalid input base."
        redirect "/"
      end
    end

    #
    # GET /:ibase/:number(.format)/:obase
    #
    # ibase: input base
    # number: number to convert
    # format: output format (txt, json, yaml, etc.). NOT OPTIONAL!!!
    # obase: output base. e.g. 2 will only return the binary conversion
    get /^\/(\d+)\/([\da-f]+)(?:\.([a-z]{3,4}))\/(\d+)$/i do |ibase, number, format, obase|
      unless NumberConverter::Converter.supported_bases.include? obase.to_i
        flash[:error] = "Invalid output base."
        redirect "/"
      end

      if NumberConverter::Converter.supported_bases.include? ibase.to_i
        begin
          converter = NumberConverter::Converter.new(number, base)
        rescue ArgumentError
          flash[:error] = "Invalid #{base_in_english(base)} number."
          redirect "/"
        end

        base = base_in_english(obase)
        @number = converter.send "to_#{base}".to_sym

        number_hash = {base.to_sym => @number}

        # Formats
        if format == "txt"
          content_type :txt
          "#{base.capitalize}: #{@number}"
        elsif format == "html"
          content_type :html
          "<p><strong>#{base.capitalize}</strong> #{@number}</p>\n"
        elsif format == "json"
          content_type :json
          number_hash.to_json
        elsif format == "yml" || format == "yaml"
          content_type :yaml
          number_hash.to_yaml
        else
          flash[:error] = "Invalid output format."
          redirect "/"
        end
      else
        flash[:error] = "Invalid input base."
        redirect "/"
      end
    end

    #
    # GET /:number(.format)/:obase
    #
    # number: number to convert
    # format: output format (txt, json, yaml, etc.). NOT OPTIONAL!!!
    # base: output base. e.g. 2 will only return the binary conversion
    get /^\/([\da-f]+)(?:\.([a-z]{3,4}))\/(\d+)$/i do |number, format, obase|
      converter = NumberConverter::Converter.new(number)

      base = base_in_english(obase)
      @number = converter.send "to_#{base}".to_sym

      number_hash = {base.to_sym => @number}

      # Formats
      if format == "txt"
        content_type :txt
        "#{base.capitalize}: #{@number}"
      elsif format == "html"
        content_type :html
        "<p><strong>#{base.capitalize}</strong> #{@number}</p>\n"
      elsif format == "json"
        content_type :json
        number_hash.to_json
      elsif format == "yml" || format == "yaml"
        content_type :yaml
        number_hash.to_yaml
      else
        flash[:error] = "Invalid output format."
        redirect "/"
      end
    end
  end
end
