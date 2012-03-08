module GridData
  module ModelStrategies
    module ActiveRecord
      extend GridData::SqlOperations
      extend self

      def init(model)
        raise GridData::ModelError, "does not seem to be a valid ActiveRecord model" unless is_active_record?(model)
        model
      end

      def is_active_record?(model)
        model.respond_to?(:ancestors) && model.ancestors.include?(::ActiveRecord::Base)
      end

      def filter(chain, filters)
        filters = JSON.parse(filters)
        filters['rules'].each do |rule|
          chain = chain.where(clause(rule))
        end
        chain
      end


    end
  end
end
