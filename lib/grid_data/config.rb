module GridData
  class Config

    def self.load_from_file(filename)
      hash = YAML.load_file(filename)
      container = self.default_config_container

    end

    def self.module_config
      self.default_config_container
    end

    def self.default_config_container
      ::ActiveSupport::OrderedOptions.new()
    end


    @@module_config = self.default_config_container
    @@model_config = self.default_model_container
  end
end
