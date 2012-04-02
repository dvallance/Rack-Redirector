module Rack
  module Redirect
    class Redirector 
    
      attr_reader :handler, :app

      def initialize(app = nil, options = {})
        raise ArgumentError, "Argument missing [ app ]. I am middleware only! I need another rack app to handle requests." if app.nil?  || !app.respond_to?(:call)
        if options[:handler] and options[:handler].respond_to?(:redirect_uri)
          @handler = options[:handler]
        else
          raise ArgumentError, "URIRedirector needs a :handler => class, that responds to method [redirect_uri]."
        end
        @app = app
      end

      def call(env)
        @env = env
        request = Rack::Request.new(env)
        begin
          redirect = @handler.redirect_uri(request.fullpath)
        rescue
        end
        if redirect.nil?
          @app.call env
        else
          [301, {"Content-Type" => "text/plain", "Location" => redirect}, ["Redirecting..."]]
        end
      end
    end
  end
end
