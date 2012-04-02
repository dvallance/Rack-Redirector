require 'minitest/autorun'
require 'rack-redirect'
require 'rack/test'
require 'mocha'

class TestFileRedirector < MiniTest::Unit::TestCase

	def setup
    @file_redirector = Rack::Redirect::FileRedirector.new(File.expand_path('test-data.csv', File.dirname(__FILE__))) 
    @redirect_hash = @file_redirector.redirect_hash
	end

  def test_initialize_errors_with_invalid_file_path
    # needs an endpoint app as this is intended to be middleware
    error = assert_raises ArgumentError do
      Rack::Redirect::FileRedirector.new('i-dont-exist')
    end
    assert_match /expects a valid existing file/, error.message
  end

  def test_initializes_and_parses_supplied_file_path
    assert !@redirect_hash.empty?
    assert_equal @redirect_hash.count, 5 
  end

  def test_redirect_uri
    assert_equal @file_redirector.redirect_uri("/old-route"), "/new-route" 
    assert_equal @file_redirector.redirect_uri("/a/b/c"), "/x/y/z" 
    assert_equal @file_redirector.redirect_uri("/somewhere"), "/somewhere-else" 
    assert_equal @file_redirector.redirect_uri("/old?params=1"), "/new?params=2" 
    assert_nil @file_redirector.redirect_uri("/invalid")
  end

end
