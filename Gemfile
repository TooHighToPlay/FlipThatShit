source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.1'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails', '~> 3.0.4'
gem 'jbuilder', '~> 1.2'
gem 'figaro', '~> 0.7.0'
gem 'foundation-rails', '~> 5.0.2.0'
gem 'haml-rails', '~> 0.4'
gem 'modernizr-rails'
gem 'therubyracer', :platform=>:ruby
gem 'thin'

gem 'angularjs-rails', '~> 1.2.0.rc3'
gem 'angular-rails-templates', '~> 0.0.4'

group :development do
  gem 'sqlite3'
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'heroku-deflater'
  gem 'newrelic_rpm'
end