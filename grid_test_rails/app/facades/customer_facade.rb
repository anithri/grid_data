module CustomerFacade
  extend self
  extend GridData::Facade
  set_model_strategy GridData::ModelStrategies::ActiveRecord
  set_paginator GridData::Paginators::Kaminari
  facade_for Customer
end
