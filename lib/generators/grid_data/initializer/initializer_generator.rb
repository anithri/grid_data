module GridData
  class InitializerGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    argument :grid_data_dir, type: :string, default: "config/grid_data", description: "Default directory for GridData
 configuration files"
    class_option :yaml_extension, type: :string, default: "yaml", description: "yaml extension to use"
    class_option :initializer_dir, type: :string, default: "config/initializers", description: "directory to save
initializer to"

    def create_initializer_file
      empty_directory grid_data_dir
      grid_defaults_target = "#{grid_data_dir}/000_grid_defaults.#{options['yaml_extension']}"
      model_defaults_target = "{grid_data_dir}/001_model_defaults.#{options['yaml_extension']}"
      initializer_target = "#{options['initializer_dir']}/grid_data.rb"
      copy_file 'grid_defaults.yaml', grid_defaults_target
      copy_file 'model_defaults.yaml', model_defaults_target
      template 'config/initializers/grid_data.rb.tt', initializer_target
    end
  end
end
