class Group < ActiveRecord::Base
  attr_accessible :name
  has_many :todos
  has_many :users
end
