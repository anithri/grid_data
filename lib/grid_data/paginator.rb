module GridData
  module Paginator
    extend self

    def determine_paginator(model)
      find_paginator_from_model(model) || find_paginator_from_global_config || no_paginator_found!(model)
    end

    protected

    def find_paginator_from_model(model)
      return false unless model.respond_to?(:grid_data_config) && model.grid_data_config.respond_to?(:[])
      coerce_to_callable(model.grid_data_config[:paginator], "it was set by #{model}.grid_data_config.paginator")
    end

    def find_paginator_from_global_config
      coerce_to_callable(GridData.config.paginator, "it was set in GridData.config.paginator")
    end

    def is_valid_paginator?(paginator)
      paginator.respond_to?(:do_paging)
    end

    def coerce_to_callable(paginator,exception_suffix = "")
      return false if paginator.nil?
      return paginator if is_valid_paginator?(paginator)
      return paginator.constantize if is_valid_paginator?(paginator.constantize)
      raise GridData::InvalidPaginatorError, "#{paginator.constantize} has no #do_paging method."
    rescue
      raise GridData::InvalidPaginatorError,
            "#{GridData.config.paginator} is not a valid Paginator.#{exception_suffix}"
    end

    def no_paginator_found!(model)
      raise GridData::NoPaginatorFoundError, "No paginator found for #{model}"
    end
  end
end
__END__
1) GridData::Paginator#determine_paginator If no GridData.config.paginator is set should raise an exception if
                      #it find an invalid paginator in the model
   Failure/Error: lambda{subject.determine_paginator(model_with_invalid_config)}.should
raise_error(GridData::InvalidPaginatorError,/SomeMessedUpThing/)
     expected GridData::InvalidPaginatorError with message matching /SomeMessedUpThing/,
                                                                    got #<NoMethodError: undefined method `grid_data' for #<Class:0x00000002bc5028>>
   # ./spec/grid_data/paginator_spec.rb:17:in `block (4 levels) in <top (required)>'
