class AddStreet2ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :street2, :string
  end
end
