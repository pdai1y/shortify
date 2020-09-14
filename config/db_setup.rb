# frozen_string_literal: true

require 'yaml'
require 'logger'

db_file = File.read('config/database.yml')
env = ENV.fetch('RACK_ENV', 'production')

DB_INFO = YAML.safe_load(db_file, aliases: true)[env].freeze

LOGGER = env == 'test' ? nil : Logger.new($stdout)
