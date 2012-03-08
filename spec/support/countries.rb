require 'active_record'
require 'kaminari'

class Country < ActiveRecord::Base
  paginates_per 20
end
