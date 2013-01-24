class Todo < ActiveRecord::Base
  attr_accessible :title, :group_id
  validates :title, length: { minimum: 1, maximum: 250 }
  belongs_to :group
  has_many :participants, dependent: :destroy
end
