require 'active_support/ordered_options'
require 'active_support/deprecation'

require_relative 'grid_data/config'

module GridData
  extend self

  @config ||= GridData::Config.global_defaults

  def config
    @config
  end

end

