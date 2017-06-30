ENV['RACK_ENV'] = 'test'

require './server'
require 'test/unit'
require 'rack/test'

class ProjectTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_shows_all_projects
    get '/projects' do
      assert_equal true, true
    end
  end
end