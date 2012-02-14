require 'active_support/inflector'
class TestStuff

  @@col_names = {id:"Ident"}

  def self.descends_from_active_record?
    true
  end

  def self.table_name
    "test_stuff"
  end

  def self.human_attribute_name(col)
    @@col_names[col] || ActiveSupport::Inflector.humanize(col)
  end

  def self.where(*opts)
    (@@where_values ||= []) << opts
    self
  end

  def self.where_values
    @@where_values || []
  end

  def self.order(order_string)
    @@order_values = *order_string
    self
  end

  def self.order_values
    @@order_values || []
  end

  def self.scrub_values_for_test
    @@where_values = @@order_values = []
    @@offset_value = @@limit_value = nil
  end

  def self.offset(val)
    @@offset_value = val
  end

  def self.offset_value
    @@offset_value
  end

  def self.limit(val)
    @@limit_value = val
  end

  def self.limit_value
    @@limit_value
  end
end

class TestStuffKaminari < TestStuff

  def self.per_page
    @@limit_value || 60
  end

  def self.page(val)
    @@kaminari_page = val
    @@offset_value = (val - 1) * self.per_page
    self
  end

  def self.per(val)
    @@limit_value = val
    @@offset_value = (@@kaminari_page - 1) * self.per_page
    self
  end

end