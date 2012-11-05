class Todo < ActiveRecord::Base
  attr_accessible :title, :group_id
  validates :title, :length => { :maximum => 250 }
  belongs_to :group
end
