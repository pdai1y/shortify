# frozen_string_literal: true

require 'sequel/core'

require_relative 'db_setup'
require_relative 'models'

DB = Sequel.connect(DB_INFO, logger: LOGGER)
