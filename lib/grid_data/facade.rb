require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/inflector'

module GridData
  module Facade

    mattr_reader :model, :model_strategy, :paginator

    def set_model_strategy(obj)
      @@model_strategy = determine_constant(obj, "GridData::ModelStrategies")
      return @@model_strategy if @@model_strategy
      raise  GridData::ModelStrategyError, "Can't find strategy for #{obj}'"
    end

    #TODO add ways to automatically determine ModelStrategy
    #TODO change set_model_strategy(obj) to set_model_strategy(obj = auto_determine_model_strategy)
    #def auto_determine_model_strategy
    #  strategy = nil
    #  raise  GridData::ModelStrategyError, "No Strategy can be determined." if strategy.nil?
    #end

    def determine_constant(obj, namespace = "")
      return obj unless obj.kind_of?(String) or obj.kind_of?(Symbol)
      obj.to_s.camelcase.safe_constantize ||
      "#{namespace}::#{obj.to_s.camelcase}".safe_constantize
    end

    def set_paginator(obj)
      @@paginator = determine_constant(obj, "GridData::Paginators")
      return @@paginator if @@paginator
      raise GridData::PaginatorError, "Can't find paginator for #{obj}'"
    end

    def facade_for(obj)
      @@model = determine_constant(obj)
      return @@model if @@model
      raise  GridData::ModelError, "Can't find model for #{obj}'"
    end

    def load_config_file(*files)
      raise ArgumentError, "no files listed" unless files.length > 0
      GridData::Config.add_new_books
    end

    def config
      GridData.config
    end

    def row_data(params)
      #PARAMS COME AS STRINGS NOT KEYS
      page = params.fetch('page',1).to_i
      rows = params.fetch('rows',10).to_i
      sidx = params['sidx']
      sord = params['sord']

      output_list = @@model_strategy.init(@@model)
      warn output_list.all
      if do_filter(params)
        output_list = @@model_strategy.filter(output_list, params['filters'])
      end

      warn output_list.all

      if sidx && sord
        output_list = @@model_strategy.sort(output_list, sidx, sord)
      end
      warn output_list.all

      total = @@model_strategy.total_rows(output_list)
      warn output_list.all

      if @@paginator
        #output_list = @@paginator.page(output_list, page, rows)
      else
        #output_list = @@model_strategy.page(output_list, page, rows)
      end
      output_list = @@model_strategy.finalize(output_list)
      warn output_list

      output = {
          total:   (total / rows) + 1,
          page:    page,
          records: total,
          rows:    output_list
      }

      return output
    end

    def do_filter(params)
      params['_search'] == "true"
    end

    def mk_grid(grid_opts, table_id, pager_id)
      javascript_tag(
          render partial: "grid/grid.js",
          locals: {  grid_options: grid_opts,
                     table_id: table_id,
                     ppager_id: pager_id
                  }
      )
    end

    def div_name
      "grid_data"
    end

    def pager_name
      div_name + "_pager"
    end

    def default_sort
      "id"
    end

    def table_caption
      "Customer"
    end

    def data_url
      "/customers.json"
    end

    def col_names
      ["Id", "Name", "Phone"]
    end

    def col_models
      [:id, :name, :phone].map{|e| col_model(e)}
    end

    def col_model(name)
      {
        name: config_entry(:model, name.to_sym, :name),
        index: config_entry(:model, name.to_sym, :index),
        align: config_entry(:model, name.to_sym, :index)
      }
    end

    def config_entry(*key_chain)
      config.fetch(*key_chain)
    end

    def default_row
      10
    end

    def row_list
      [10,25,50]
    end

  end
end
