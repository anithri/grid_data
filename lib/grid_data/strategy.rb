require_relative '../grid_data'

module GridData
  module Strategy
    extend self
    REQUIRED_STRATEGY_METHODS = [:applies_to_model?]

    def has_strategies?
      return false unless GridData.config.registered_strategies.respond_to?(:each)
      return false if GridData.config.registered_strategies.empty?
      return true
    end

    def is_valid_strategy?(strategy)
      REQUIRED_STRATEGY_METHODS.all? { |r| strategy.respond_to?(r) }
    end

    def no_strategy_found(model)
      raise GridData::NoStrategyFoundError, "for #{model}"
    end

    def determine_strategy(model)
      raise GridData::NoStrategyFoundError, "No strategies found" unless has_strategies?
      result = GridData.config.registered_strategies.detect(lambda { no_strategy_found(model) }) do |strategy|
        raise GridData::InvalidStrategyError, "invalid strategy #{strategy}" unless is_valid_strategy?(strategy)
        strategy.applies_to_model?(model)
      end
      raise GridData::NoStrategyFoundError, "for #{model}" unless result
      return result
    end
  end
end
