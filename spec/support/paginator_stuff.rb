class ValidPaginator
  def self.do_paging
  end
end

class ModelWithValidConfig
  def self.grid_data_config
    {paginator: ValidPaginator}
  end
end

class ModelWithInvalidConfig
  def self.grid_data_config
    {paginator: "AnyOldThing"}
  end
end
