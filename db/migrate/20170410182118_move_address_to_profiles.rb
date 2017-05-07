class MoveAddressToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :street, :string
    add_column :profiles, :street2, :string
    add_column :profiles, :city, :string
    add_column :profiles, :state, :string
    add_column :profiles, :zip, :string

    remove_column :users, :street
    remove_column :users, :street2
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :zip

    change_column :users, :rating, :float
  end
end
