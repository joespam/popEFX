class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.float :rating
      t.integer :rater
      t.integer :rated

      t.timestamps null: false
    end
  end
end
