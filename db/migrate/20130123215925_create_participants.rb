class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :user_id
      t.integer :todo_id

      t.timestamps
    end
    add_index :participants, :todo_id
  end
end
