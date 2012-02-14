module GridData
  module Paginator
    extend self

    def determine_paginator(model)
      output = extract_from_model_grid_data || extract_from_grid_data_config
      test_paginator(output)
      return output
    end

    def extract_from_model_grid_data
      return false unless @grid_model_data && @grid_model_data.respond_to(:[]) && grid_model_data[:paginator]
      begin
        return grid_data_model[:paginator].constantize
      rescue NameError
        raise GridData::InvalidPaginatorError, "invalid paginator #{grid_data_model[:paginator].  Does not resolve to
        constant}"
      end
    end

    def extract_from_grid_data_config
      return false unless GridData.config.paginator
      
    end

    def test_paginator(mod)

    end
  end
end