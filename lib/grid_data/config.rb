require 'pathname'

YAML.add_builtin_type("omap") do |type, val|
  ActiveSupport::OrderedOptions[val.map(&:to_a).map(&:first)]
end
module GridData

  module Config
    extend self

    DEFAULTS = {
        config_dir: Dir.pwd + "/config/grid_data",
        yaml_extension: "yaml",
        global_config_file_name: Dir.pwd + "/config/grid_data/global_config.yaml",
        missing_file_warnings: :warn,
        loaded_global_config: false
        }

    def global_defaults
      options = ::ActiveSupport::OrderedOptions.new().merge(DEFAULTS).clone

      options.column_defaults = ::ActiveSupport::OrderedOptions.new()
      options.columns = ::ActiveSupport::OrderedOptions.new()
      options.meta = ::ActiveSupport::OrderedOptions.new()
      options.grid = ::ActiveSupport::OrderedOptions.new()

      if File.exists?(options.global_config_file_name)
        options.merge!(YAML.load_file(options.global_config_file_name))
        options.loaded_global_config = true
      end

      return options
    end

    def load_global_from_file(filename, append = false)
      config = append ? GridData.config : ActiveSupport::OrderedOptions.new().merge!(DEFAULTS).clone
      config = config.merge(YAML.load_file(filename)).clone
      config.global_config_file_name = filename
      config.loaded_global_config = true
      return config
    end
  end
end

