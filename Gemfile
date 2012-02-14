source "http://rubygems.org"

# Declare your gem's dependencies in grid_data.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

group :development, :test do
  gem 'sqlite3'
  gem 'activerecord', require: 'active_record'
  gem 'irbtools'
  gem 'spork'
  gem 'rspec'
  gem 'factory_girl'
  gem 'guard', git: 'https://github.com/guard/guard.git'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-spork'

  require 'rbconfig'

  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    gem 'ruby_gntp',  '~> 0.3.4', :require => false
  elsif RbConfig::CONFIG['target_os'] =~ /linux/i
    gem 'libnotify',  '~> 0.7.1', :require => false
    gem 'rb-inotify'
  elsif RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
    gem 'win32console', :require => false
    gem 'rb-notifu', '>= 0.0.4', :require => false
  end

  #for testing specific strategies and paginators
  gem 'kaminari'

end

