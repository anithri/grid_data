module GridData
  module Utility
    extend self

    def fill_with_col_name(col_data, auto_keys = nil)
      auto_keys ||= GridData.config.auto_keys || [:name, :index]
      return col_data if auto_keys.empty?
      col_data.each do |key, val|
        auto_keys.each do |entry|
          val[entry] = key.to_s if val[entry].nil?
        end
      end
      col_data
    end
  end
end