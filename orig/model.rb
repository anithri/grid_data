require 'active_support/concern'
require 'andand'

module GridData::Model
  extend ActiveSupport::Concern

  module ClassMethods
    def collect_grid_info
      table_name = self.table_name
      if File.exists?("config/grid_data/#{self.table_name}_grid.yaml")
        return YAML.load_file("config/grid_data/#{self.table_name}.yaml")
      end
    end

    def can_collect_grid_info?
      self < ActiveRecord::Base || self < Draper::Base
    end

    def to_grid(params)
      page = params.fetch('page', 1).to_i
      rows = params.fetch('rows',30).to_i
      sidx = params['sidx']
      sord = params['sord']

      output_list = self

      #filter
      if params['_search'] == 'true'
        filters = JSON.parse(params['filters'])
        filters['rules'].each do |rule|
          data = '%' + rule['data'] + '%'
          output_list = output_list.where("#{rule['field']} LIKE ?", data)
        end
      end

      #sorting
      unless sidx.nil?
        warn "Sorting on: #{sidx} #{sord}"
        output_list = output_list.order("#{sidx} #{sord}")
      end

      total = output_list.count

      #pagination
      output_list = output_list.page(page).per(rows)

      output = { total: (total / rows) + 1,
                 page: page,
                 records: total,
                 rows: output_list
               }
      return output
    end

    def col_names
      @grid_data_info.map{|h| h[:name].intern}
    end

    def col_models
      @grid_data_info
    end
  end

  #For code that needs to be executed when module is included
  included do
    attr_reader :grid_model_strategy
    @grid_data_strategy = GridData::Strategy.determine(self)
    include @grid_data_strategy

    @grid_data_info = self.collect_grid_info
  end
end

