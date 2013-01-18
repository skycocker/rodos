class CreateFbRelationships < ActiveRecord::Migration
  def change
    create_table :fb_relationships do |t|
      t.integer :fb_group, limit: 8
      t.integer :rodos_group

      t.timestamps
    end
  end
end
