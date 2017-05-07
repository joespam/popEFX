class AddHiddenToKeywords < ActiveRecord::Migration
  def change
    add_column :keywords, :hidden, :boolean
  end
end
