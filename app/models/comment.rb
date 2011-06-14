# == Schema Information
# Schema version: 20110608195226
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  comment    :text
#  user_id    :integer
#  book_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Comment < ActiveRecord::Base
    
    attr_accessible :comment, :book_id
    
    belongs_to :user
    belongs_to :book
    
    validates :comment, :presence => true
    validates :user_id, :presence => true
    validates :book_id, :presence => true
    
    default_scope :order => 'comments.created_at DESC'

end
