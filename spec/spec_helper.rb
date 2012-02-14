require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
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

  Dir["support/**/*.rb"].each {|f| require_relative f}
  require_relative 'support/test_stuff'

  require 'active_record'
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'spec/support/db/test.db')
  ActiveRecord::Migrator.migrate("spec/support/db/migrate/201202131745_create_stuff.rb")
end

Spork.each_run do
  # This code will be run each time you run your specs.

  require_relative '../lib/grid_data'
  require_relative '../lib/grid_data/strategy'

  require_relative 'support/stuff'
  GridData.config.model_grid_yaml_path = 'spec/config'
  

end
