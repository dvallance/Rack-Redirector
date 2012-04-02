require 'minitest/autorun'
require 'rack-redirect'
require 'rack/test'
require 'mocha'

class TestRedirector < MiniTest::Unit::TestCase
  include Rack::Test::Methods

	def setup
    @endpoint = Proc.new{|env| [200,{'Content-Type' => 'text/html'},["Hello World"]]}
    @mock_handler = mock()
    @mock_handler.stubs(:redirect_uri).returns("/test")
    @redirector = Rack::Redirect::Redirector.new(@endpoint, :handler => @mock_handler)
	end

  def app
    @redirector
  end


  def test_initialize_errors_with_invalid_app_argument
    # needs an endpoint app as this is intended to be middleware
    error = assert_raises ArgumentError do
      Rack::Redirect::Redirector.new
    end
    assert_match /I am middleware only/, error.message

    # needs a handler that responds to :handler
    error = assert_raises ArgumentError do
      Rack::Redirect::Redirector.new mock() 
    end
    assert_match /I am middleware only/, error.message

  end

  def test_initialize_errors_with_invalid_handler
    # no handler supplied
    error = assert_raises ArgumentError do
      Rack::Redirect::Redirector.new @endpoint 
    end
    assert_match /needs a :handler/, error.message

    # handler doesn't respond to :redirect_url
    error = assert_raises ArgumentError do
      Rack::Redirect::Redirector.new @endpoint, :handler => mock()
    end
    assert_match /needs a :handler/, error.message
  end

  def test_call_passes_handlers_redirect
    # nil results in a pass through and no redirect
    @mock_handler.stubs(:redirect_uri).returns(nil)
    get '/some-call'
    assert_match /Hello World/, last_response.body
  end

  def test_call_uses_handlers_redirect_when_available
    # nil results in a pass through and no redirect
    @mock_handler.stubs(:redirect_uri).returns("/elsewhere")
    get '/some-call'
    assert_match /Redirecting/, last_response.body
    assert_equal 301, last_response.status
  end
end
