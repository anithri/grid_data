module GridData
  class GridDataError < StandardError; end

  class StrategyError < GridDataError; end
  class NoStrategyFoundError < StrategyError; end
  class InvalidStrategyError < StrategyError; end

  class PaginatorError < GridDataError; end
  class NoPaginatorFoundError < PaginatorError; end
  class InvalidPaginatorError < PaginatorError; end
end
