module GridData
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      def model_table_name
        @grid_data_strategy.table_name(self)
      end

      def strategy
        @grid_data_strategy
      end

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

      def do_filter(filters)
        @grid_data_strategy.do_filter(filters)
      end

    end


    #For code that needs to be executed when module is included
    included do
      @grid_data_strategy = ::GridData::Strategy.determine_strategy(self)
      @grid_data_info, @grid_data_columns = self.collect_grid_info
    end


  end
end