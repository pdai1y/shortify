# frozen_string_literal: true

require 'rspec/core/rake_task'

namespace :db do
  migration = lambda do |version|
    require_relative 'config/db'
    Sequel.extension :migration
    Sequel::Migrator.apply(DB, 'migrate', version)
  end

  desc 'Create the database'
  task :create do
    require_relative 'config/db_setup'
    require 'sequel/core'
    # Ensure that the DB is created prior to contining
    # Utilze MySQL sys database to fufill Sequels db requirement
    Sequel.connect(DB_INFO.merge(database: 'sys')) do |db|
      db.execute "CREATE DATABASE IF NOT EXISTS #{DB_INFO['database']}"
    end
  end

  desc 'Migrate database to latest version'
  task :migrate do
    migration.call(nil)
  end
end

RSpec::Core::RakeTask.new(:spec)

task default: [:spec]
