#initialization file for GridData
GridData.setup do |config|
  config.config_dir = Rails.root + "config/grid_data"
  config.yaml_extension = "yaml"
  #config.extra_files = []
end
