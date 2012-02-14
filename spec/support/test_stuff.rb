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
end