class AddRatingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rating, :float, :default => 5.0
  end
end
