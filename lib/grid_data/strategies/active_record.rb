module GridData::Strategies
  module ActiveRecord
    extend self

    def applies_to_model?(model)
      return self if detect_ar_class?(model)
    end

    def table_name(model)
      table_name = model.table_name
    end

    def humanized_col_name(model,col)
      model.human_attribute_name(col)
    end

    def do_filter(chain,filters)
      filters['rules'].each do |rule|
        data = "%#{rule['data']}%"
        chain = chain.where("#{rule['field']} LIKE ?", data)
      end
      chain
    end

    protected
    def detect_ar_class?(model)
      model.respond_to?(:descends_from_active_record?) && model.descends_from_active_record?
    end
  end
end