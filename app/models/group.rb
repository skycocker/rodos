class Group < ActiveRecord::Base
  attr_accessible :name
  has_many :relationships
  has_many :users, through: :relationships
  has_many :todos
end
