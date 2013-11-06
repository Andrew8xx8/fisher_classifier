# coding: utf-8

require 'sfk'
require 'bundler/setup'
Bundler.require(:default, :development, :test)

require 'simplecov'
if ENV["COVERAGE"]
  SimpleCov.start
  files = Dir[File.join(File.dirname(__FILE__), "../lib/**/*.rb")]
  files.each {|file| require file }
end

require 'webmock/rspec'
require File.expand_path('../support/stub_helpers', __FILE__)

SFK::RSpec.configure do |config|
  config.root_path = Pathname(File.join(File.dirname(__FILE__), '../'))
  config.apps_path = Pathname(File.join(File.dirname(__FILE__), 'support'))
  config.shared_app_contexts [:main] do
    let(:base) {app.view('base')}
  end

  include StubHelpers
end
