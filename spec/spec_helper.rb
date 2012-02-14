require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  SPEC_DIR=File.dirname(__FILE__)
  SUPPORT_DIR = File.join(SPEC_DIR, "support")
  DB_DIR = File.join(SUPPORT_DIR, "db")

  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  require 'rspec'
  require 'factory_girl'

  RSpec.configure do |config|
    config.color = true
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.filter_run :focus
  end

  Dir["#{SUPPORT_DIR}/*.rb"].each {|f| require_relative f}

  #require 'active_record'
  #ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: "#{DB_DIR}/grid_data_test.sqlite3")
  #ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'my_models'")
  #load "#{DB_DIR}/schema.rb"
  #load "#{DB_DIR}/models.rb"
end

Spork.each_run do
  # This code will be run each time you run your specs.
  require_relative "#{SUPPORT_DIR}/test_stuff"

  require_relative '../lib/grid_data'

  GridData.config.model_grid_yaml_path = 'spec/config'

end
