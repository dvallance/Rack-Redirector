#\ -p 3000 -E development -d

#require 'rack/debug'
require 'rack-redirect'

use Rack::Redirect::Redirector, :handler => Rack::Redirect::FileRedirector.new(File.dirname(__FILE__) + "/test/test-data.csv")

run Proc.new{|env| [200,{'Content-Type' => 'text/html'},["Hello World"]]}
