ActiveRecord::Schema.define do
  self.verbose = false

  create_table :favorites, force: true do |t|
    t.string :name
    t.string :color
    t.integer :num_dogs
    t.date :birthday

    t.timestamps
  end

end