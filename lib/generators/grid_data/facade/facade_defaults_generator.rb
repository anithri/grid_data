module GridData
  class FacadeDefaultsGenerator < Rails::Generators::NamedBase

    source_root File.expand_path('../templates', __FILE__)
    argument :model_name, type: :string, description: "Name of the model"

    def create_facade_module_file
      path = Rails.root + "/app/facadesrails g "
      empty_directory path

      facade_target = "#{path}/#{model_name.underscore}_facade.rb"
      warn facade_target
      template 'facade.rb.tt', model_target
    end
  end
end
