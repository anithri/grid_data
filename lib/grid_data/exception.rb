module GridData
  class GridDataError < StandardError; end

  class ConfigFileError < GridDataError; end
  class ModelStrategyError < GridDataError; end
  class PaginatorError < GridDataError; end
  class ModelError < GridDataError; end

end

