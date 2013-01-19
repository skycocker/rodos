class AddIndexToFbGroup < ActiveRecord::Migration
  def change
    add_index :fb_relationships, :fb_group
  end
end
