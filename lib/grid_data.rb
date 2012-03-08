require 'active_support/ordered_options'
require 'active_support/deprecation'
require 'active_support/concern'

#grid_data includes at bottom
module GridData
  extend self

  def self.reset
    @settings = ActiveSupport::OrderedOptions.new
    @settings.config_dir = Dir.pwd + "/config/grid_data"
    @settings.yaml_extension = "yaml"
    @settings.extra_files = []

    @config = nil
  end

  reset

  def self.config
    @config
  end

  def self.setup(&block)
    block.call(@settings)
    init
  end

  def self.settings
    @settings
  end

  def self.init
    @config = GridData::Config.global_defaults(@settings)
  end

  def add_new_books(*file_list)
    files = GridData::Config.prep_extra_files(*file_list)
    new = GridData::Config.load_config_files_from_list(files)
    @config.add_new_books(new)
  end

end

require_relative 'grid_data/config'
require_relative 'grid_data/exception'
require_relative 'grid_data/sql_operations'
require_relative 'grid_data/facade'
require_relative 'grid_data/model_strategies/active_record'
