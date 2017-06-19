class AddAttachmentHeroimageToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.attachment :heroImage
    end
  end

  def self.down
    remove_attachment :profiles, :heroImage
  end
end
