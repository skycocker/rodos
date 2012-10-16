class Todo < ActiveRecord::Base
  attr_accessible :title
  validates :title, :length => { :maximum => 250 }
  belongs_to :group
end
