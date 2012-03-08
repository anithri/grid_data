ActiveRecord::Schema.define :version => 0 do
  create_table :colors, :force => true do |t|
    t.string :name
    t.string :country
  end
end
