module GridData
  class GridDataError < StandardError; end
  class StrategyError < GridDataError; end
  class NoStrategyFoundError < StrategyError; end
  class InvalidStrategyError < StrategyError; end
end
