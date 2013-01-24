class Participant < ActiveRecord::Base
  attr_accessible :user_id, :todo_id
  validates_uniqueness_of :user_id, scope: :todo_id
  belongs_to :todo
  belongs_to :user
end
