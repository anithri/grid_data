require 'active_support/ordered_options'
require 'active_support/concern'
require 'active_support/deprecation'

module GridData
  extend self

  @config = ::ActiveSupport::OrderedOptions.new()
  attr_reader :config

end

#require the rest of the gem after config has been initialized
require_relative 'grid_data/exception'
require_relative 'grid_data/utility'
require_relative 'grid_data/default_config'

require_relative 'grid_data/strategy'
require_relative 'grid_data/strategies/active_record'

require_relative 'grid_data/paginator'
require_relative 'grid_data/paginators/kaminari_paginator'
#require_relative 'grid_data/paginators/limit_offset_paginator'
#require_relative 'grid_data/paginators/will_paginate_paginator'

require_relative 'grid_data/model'
