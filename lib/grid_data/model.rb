module GridData
  module Model
    def model_grid_yaml_file
      GridData.config.model_grid_yaml_path + "/#{self.model_table_name}_grid.yaml"
    end

    def collect_grid_info
      if File.exists?(model_grid_yaml_file)
        data = YAML.load_file(model_grid_yaml_file)
        grid_info = data[:grid] || {}
        fill_col_names = data[:meta] && data[:meta][:fill_col_names]
        col_model_info = GridData::Utility.fill_with_col_name(data[:columns], fill_col_names)
        return grid_info, col_model_info
      end
    end

    def col_header_names
      @grid_data_columns.map do |col_name, options|
        options[:header] || @grid_data_strategy.humanized_col_name(self, col_name)
      end
    end

    def col_models
      @grid_data_columns.values
    end

    def grid_data_config
      @@grid_data_config ||= GridData::DefaultConfig.model
    end

    #For code that needs to be executed when model is extended
    def self.extended(klass)
      @@grid_data_config = GridData::DefaultConfig.model
      @@grid_data_strategy = ::GridData::Strategy.determine_strategy(self)
      @@grid_data_paginator = ::GridData::Paginator.determine_paginator(self)
      @grid_data_info, @grid_data_columns = self.collect_grid_info
      #@grid_data_paginator == ::GridData::Paginator.determine_paginator(self)
    end
  end
end
