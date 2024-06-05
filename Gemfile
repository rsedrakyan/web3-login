source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.0.8', '>= 7.0.8.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

gem 'jsbundling-rails', '~> 1.3'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'redis', '~> 4.0'

# Use Sass to process CSS
gem 'sassc-rails'

gem 'eth', require: false

group :development, :test do
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 6.1.0'
end

group :development do
  gem 'rubocop', require: false
end
