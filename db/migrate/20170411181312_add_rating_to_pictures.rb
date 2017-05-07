class AddRatingToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :rating, :float, :default => 5.0
  end
end
