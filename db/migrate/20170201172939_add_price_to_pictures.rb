class AddPriceToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :price, :decimal, precision: 10, scale: 2
  end
end
