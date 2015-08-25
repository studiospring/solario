source 'https://rubygems.org'
ruby '2.2.2'
gem 'rails', '~>4.2'

gem 'pg', '0.17.1' #postgres
gem 'devise'

group :assets do
  # Use SCSS for stylesheets
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'
end
  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails'
  #put this outside assets group, or heroku will complain
  gem 'bootstrap-sass', '~>3.0.3.0'
  gem 'sass-rails', '~> 4.0.2'

group :development, :test do
  gem 'rspec-rails'
  gem 'poltergeist' #headless driver for js testing
  gem 'rails-footnotes', '>= 3.7.9'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'spork-rails', github: 'sporkrb/spork-rails'
  gem 'guard-spork'
  gem 'childprocess', '0.3.6'
  gem 'capybara'
  gem 'annotate', '>=2.5.0'
  gem 'rubocop'
  gem 'spring'
end
group :test do
  gem 'webmock' #for testing http requests to pvoutput.org
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

gem 'unicorn'
gem 'slim'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
