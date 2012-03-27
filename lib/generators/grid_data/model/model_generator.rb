module GridData
  class ModelGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    argument :model_name, type: :string, description: "Name of the model"

    def create_model_file
      path = GridData.settings.config_dir
      last_model = Dir.glob("#{path}/*_*_model.*").last
      next_num = "100"
      next_num = File.basename(last_model).match(/^(\d+)_/)[1].succ if last_model
      model_target = "#{path}/#{next_num}_#{model_name.underscore}_model.#{GridData.settings.yaml_extension}"
      warn model_target
      template 'model.yaml.tt', model_target
    end

  end
end
