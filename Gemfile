source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails'

ruby '2.4.2'

gem 'rails', '~> 5.1.4'
gem 'rails-i18n', '~> 5.0.0'

gem 'pg', '~> 0.18'
gem 'redis', '~> 3.0'
gem 'redis-rails'

gem 'cancancan'
gem 'devise'
gem 'devise-i18n'
gem 'jwt', '~>2.1.0'

gem 'puma', '~> 3.7'
gem 'rack-cors', :require => 'rack/cors'

gem 'jbuilder', '~> 2.5'
gem 'slim-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'

gem 'carrierwave', git: 'https://github.com/carrierwaveuploader/carrierwave'
gem 'mini_magick'
gem 'carrierwave-imageoptimizer'

gem 'activeadmin', '~> 1.0.0.pre5'

gem 'seed-fu', '~> 2.3'

gem 'sidekiq', git: 'https://github.com/mperham/sidekiq'

gem 'httparty'
gem 'phony'
gem 'geocoder'
gem 'addressable', require: 'addressable/uri'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'better_errors'

  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rubocop', require: false
  gem 'rails-controller-testing'
  gem 'rspec_api_documentation'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'bullet'
  gem 'annotate', '~> 2.7', git: 'https://github.com/ctran/annotate_models'
end

group :test do
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem "fakeredis", :require => "fakeredis/rspec"
end

group :production do
  gem 'newrelic_rpm'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
