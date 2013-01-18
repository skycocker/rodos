class FbRelationship < ActiveRecord::Base
  attr_accessible :fb_group, :rodos_group
  belongs_to :group
  
  validates_uniqueness_of :fb_group, scope: :rodos_group
end
