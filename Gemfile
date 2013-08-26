source 'https://rubygems.org'

#gem 'rails', '4.0.0'
gem 'rails', github: 'rails/rails', branch: '4-0-stable'

# Use sqlite3 as the database for Active Record
gem 'pg', '0.15.1' #postgres

group :assets do
  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails'
  # Use SCSS for stylesheets
  #gem 'sass-rails', '~> 4.0.0'
  gem 'bootstrap-sass'
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'selenium-webdriver', '2.0.0'
  gem 'rails-footnotes', '>= 3.7.9'
  gem 'factory_girl_rails'
  gem 'guard-rspec', '2.5.0'
  gem 'spork-rails', github: 'sporkrb/spork-rails'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.6'
  gem 'capybara', '2.1.0'
end
group :production do
  gem 'rails_12factor', '0.0.2' #used by Heroku
end

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
