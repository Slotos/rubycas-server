# encoding: UTF-8
require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/strategy_dummy'

include Rack::Test::Methods

$LOG = Logger.new(File.basename(__FILE__).gsub('.rb','.log'))

RSpec.configure do |config|
  config.include Capybara::DSL
end

describe 'CASServer strategies' do
  before :all do
    app = load_server(File.dirname(__FILE__) + "/strategy_config.yml")
    @browser = Rack::Test::Session.new( Rack::MockSession.new( app ) )
  end

  describe "login_links writer/accessor" do
    it "should be empty initially" do
      CASServer::Server.login_links.should eq([])
    end

    it "should provide push accessor to push string into it" do
      string = "TEST STRING PLEASE IGNORE"
      CASServer::Server.add_login_link string
      CASServer::Server.login_links.should include(string)
    end
  end

  describe "establish_session" do
    it "should set tgc" do
      @browser.get '/confirm_authentication'
      @browser.instance_variable_get(:@rack_mock_session).cookie_jar["tgt"].should =~ /^TGC-[0-9rA-Z]+$/
    end

    it "should redirect to service if service is given" do
      service = "http://somewhere.else/"
      visit "/confirm_authentication?service=#{service}"
      page.current_url.should =~ Regexp.new("^#{service}\\?ticket=ST-[0-9rA-Z]+$")
    end

    it "should not redirect to service if service is not a valid URI" do
      service = CGI.escape("Hey, I'm not an URI, seriously!")
      @browser.get "/confirm_authentication?service=#{service}"
      @browser.last_response.should_not be_redirect
    end
  end
end
