require "sinatra/base"
require "erb"
require "rack-flash"

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

    get "/" do
      erb :main
    end

    post "/" do
      if params[:number].empty?
        flash[:error] = "You forgot to submit a number!"
        redirect "/"
      end

      # Validation bitch!
      if params[:number] =~ /[^0-9a-f]/i
        flash[:error] = "You submitted an invalid number!"
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
