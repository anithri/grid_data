require 'active_support/ordered_options'


module GridData
  extend self

  @config = ActiveSupport::OrderedOptions.new()
  attr_reader :config

end

#require the rest of the gem after config has been initialized
require_relative 'grid_data/exception'
require_relative 'grid_data/strategy'

