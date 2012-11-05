class AddGroupIdToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :group_id, :integer
    add_index :todos, :group_id
  end
end
