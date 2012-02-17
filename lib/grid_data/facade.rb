require 'active_support/core_ext/module/attribute_accessors'

module GridData
  module Facade

    mattr_reader :model_strategy, :paginator

    def set_model_strategy(obj)
      @@model_strategy = obj
    end
  end
end
