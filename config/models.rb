# frozen_string_literal: true

require_relative 'db'
require 'sequel/model'

Sequel::Model.plugin :prepared_statements
