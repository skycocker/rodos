class Group < ActiveRecord::Base
  attr_accessible :name
  validates :name, length: { minimum: 1, maximum: 250 }
  has_many :relationships
  has_many :users, through: :relationships
  has_many :todos
end
