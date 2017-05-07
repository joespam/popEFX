class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :follower
      t.integer :following

      t.timestamps null: false
    end
  end
end
