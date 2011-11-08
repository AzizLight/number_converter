require "sinatra/base"
require "erb"

require_relative "./number_converter/version"
require_relative "./number_converter/converter"

module NumberConverter
  class Application < Sinatra::Base
    Rack::MethodOverride

    configure do
      set :root, File.expand_path(File.join(File.dirname(__FILE__), ".."))
      set :app_file, __FILE__
    end

    get "/" do
      erb :main
    end

    post "/" do
      if params[:number].empty?
        # FIXME: Add a flash message.
        redirect "/"
      end

      # Validation bitch!
      if params[:number] =~ /[^0-9a-f]/i
        redirect "/"
      end

      if params[:base].nil? || params[:base].empty?
        converter = NumberConverter::Converter.new(params[:number])
      else
        converter = NumberConverter::Converter.new(params[:number], params[:base])
      end

      @binary  = converter.to_binary
      @decimal = converter.to_decimal
      @hex     = converter.to_hex

      erb :main
    end
  end
end
