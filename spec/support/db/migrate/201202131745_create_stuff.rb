class CreateStuff < ActiveRecord::Migration
  def change
    create_table :stuff do |t|
      t.string :name, :color
      t.integer :num_dogs
    end
  end
end
