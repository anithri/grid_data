require 'active_support/ordered_options'
require 'active_support/deprecation'
require 'active_support/concern'

require_relative 'grid_data/config'
require_relative 'grid_data/exception'
require_relative 'grid_data/facade'

module GridData
  extend self

  @config ||= GridData::Config.global_defaults

  def config
    @config
  end

  def load_config_from_file(filename, append = false)
    GridData::Config.global_config_file_name= filename
    @config = GridData::Config.load_global_from_file(filename,append)
  end

end

