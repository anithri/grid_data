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
      page = params.fetch('page',1).to_i
      rows = params.fetch('per',1).to_i
      sidx = params['sidx']
      sord = params['sord']

      output_list = @@model_strategy.init(@@model)

      if do_filter(params)
        output_list = @model_strategy.filter(output_list, params)
      end
      if sidx && sord
        output_list = @@model_strategy.sort(output_list, sidx, sord)
      end

      if @@paginator
        output_list = @@paginator.page(output_list, page, rows)
      else
        output_list = @@model_strategy.page(output_list, page, rows)
      end
      return output_list
    end

    def do_filter(params)
      params['_search'] == "true"
    end

  end
end
