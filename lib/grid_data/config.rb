require 'config_library'
require 'pathname'
module GridData
  module Config
    extend self

   # @settings = {
   #    config_dir: Dir.pwd + "/config/grid_data",
   #    yaml_extension: "yaml",
   #    extra_files: []
   #}

    def global_defaults(settings)
      file_list = prep_extra_files(settings[:extra_files])
      file_list += generate_default_file_list(settings[:config_dir], settings[:yaml_extension])

      ConfigLibrary::Base.new(load_config_files_from_list(file_list))
    end

    def generate_default_file_list(top_dir, yaml_ext = 'yaml')
      return [] if top_dir.nil?
      raise ConfigError, "config_dir:#{top_dir} does not exist." unless Dir.exist?(top_dir)
      top_dir = "#{top_dir}/**/*.#{yaml_ext}"
      Pathname.glob(top_dir).map(&:expand_path)
    end

    def prep_extra_files(file_list)
      files = file_list.flatten.map{|f| Pathname.new(f)}
      warn "prep: #{files.inspect}"
      invalid = files.reject(&:exist?)
      return files if invalid.empty?
      raise GridData::ConfigError, "extra_files[#{invalid.map(&:to_s)}] do not exist."
    end

    def load_config_files_from_list(*file_list)
      file_list.flatten!
      out = {}
      file_list.each do |file|
        book_name = file.basename.to_s.chomp(file.extname).intern
        out[book_name] = YAML.load_file(file)
      end
      out
    end
  end
end

