require 'pathname'
require 'deep_merge/rails_compat'
require 'active_support/core_ext/module/attribute_accessors'
module GridData

  module Config
    extend self

    mattr_accessor :global_config_file_name, :on_missing_config_file, :global_config

    REPLACE = false
    APPEND = true

    def mk_default_config
      ::ActiveSupport::OrderedOptions.new.tap do |new_config|
        new_config.config_dir            = Dir.pwd + "/config/grid_data"
        new_config.yaml_extension        = "yaml"
        new_config.column_defaults       = ::ActiveSupport::OrderedOptions.new()
        new_config.columns               = ::ActiveSupport::OrderedOptions.new()
        new_config.meta                  = ::ActiveSupport::OrderedOptions.new()
        new_config.grid                  = ::ActiveSupport::OrderedOptions.new()
      end

    end

    self.global_config_file_name = Dir.pwd + "/config/grid_data/global_config.yaml"
    self.on_missing_config_file  = :warn
    self.global_config           = mk_default_config

    def global_defaults
      load_global_from_file(self.global_config_file_name, APPEND)
    end

    def load_global_from_file(filename, append = false)
      orig_config = append ? self.global_config : mk_default_config
      add_file_to_hash(orig_config, filename)
    end

    def add_file_to_hash(old_hash, filename)
      return old_hash unless check_config_file(filename)
      merge_hash(old_hash, YAML.load_file(filename))
    end

    def merge_hash(to, from)
      from.deeper_merge(to)
    end

    def check_config_file(filename)
      return true if File.exists?(filename)
      case self.on_missing_config_file
      when :warn
        warn "GridData::Config could not load config file: #{filename}"
      when :raise
        raise ConfigFileError, "GridData::Config could not load config file: #{filename}"
      else
        #noop
      end
      return false
    end
  end
end

