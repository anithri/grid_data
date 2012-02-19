# GridData

GridData provides a Facade that makes delivering data to a jqGrid easier.

## Installation

Add GridData to your Gemfile

```ruby
gem 'grid_data'
```

Add an initializer to set global configuration and defaults.

```ruby
GridData.config do |config|
  config.yaml_extension = "yaml"
  config.config_dig = File.join(Rails.root,'config','grid_data')
end
```

Load in a YAML file for global configuration

```ruby
#This will wipe out any existing configuration
GridData.load_config_from_file('app/grid_data/global_config.yaml')
#passing a true value as a second parameter appends the file to your config instead of overwriting it
GridData.load_config_from_file('app/grid_data/global_config.yaml', :append)
```

Create a GridDataFacade for each model you wish to use jqGrid with.  Call methods to configure.

```ruby
module UserGridData
  extend GridData::Facade

  grid_data_model :active_record
  grid_data_paginator :kaminari
  load_config_file

end
```

Call from your controller
TODO make more accurate

```ruby
def index
  @users = UserGridData.to_grid(params)
end
```

