# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'database_cleaner-sequel'
require 'factory_bot'
require 'pry'
require 'rack/test'

ENV['RACK_ENV'] = 'test'
APP = Rack::Builder.parse_file("config.ru").first

DatabaseCleaner[:sequel].strategy = :transaction

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.before(:each) do
    DatabaseCleaner[:sequel].start
  end

  config.after(:each) do
    DatabaseCleaner[:sequel].clean
  end
end
