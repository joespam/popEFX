class RenameIteminKeywordsToPictureId < ActiveRecord::Migration
  def change
  	rename_column :keywords, :item, :picture_id
  end
end
