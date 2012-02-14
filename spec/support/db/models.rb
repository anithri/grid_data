class Favorite < ActiveRecord::Base

end


class FavoriteKaminari < Favorite
end

class FavoriteWillPaginate < Favorite

end
YAML.load_file(File.dirname(__FILE__) + '/favorite_data.yaml').each do |entry|
  Favorite.create(entry)
end
