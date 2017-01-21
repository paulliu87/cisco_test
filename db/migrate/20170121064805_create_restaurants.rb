class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
    	t.string 	:name
    	t.integer 	:rating
		t.integer 	:normal
		t.integer 	:vegetarian
		t.integer 	:nut_free
		t.integer 	:gluten_free
		t.integer 	:fish_free
      t.timestamps
    end
  end
end
