require 'active_support/ordered_options'
require 'active_support/deprecation'
require 'active_support/concern'

#grid_data includes at bottom
module GridData
  extend self

  @settings = {
      config_dir: Dir.pwd + "/config/grid_data",
      yaml_extension: "yaml",
      extra_files: []
  }
  @config = nil

  def self.config
    @config
  end

  def self.settings
    @settings
  end

  def self.init
    @config = GridData::Config(@settings)
  end
end

require_relative 'grid_data/config'
require_relative 'grid_data/exception'
require_relative 'grid_data/facade'

