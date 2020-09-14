source 'https://rubygems.org/'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'babosa', '1.0.3'
gem 'mysql2', '0.5.3'
gem 'puma', '4.3.6'
gem 'roda', '3.35.0'
gem 'sequel', '5.36.0'

group :development do
  gem 'pry', '0.13.1'
end

group :test do
  gem 'database_cleaner-sequel', '1.8.0'
  gem 'factory_bot', '6.1.0'
  gem 'simplecov', '0.19.0', require: false
  gem 'rack-test', '1.1.0'
  gem 'rspec', '3.9.0'
end
