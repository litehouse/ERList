# == Schema Information
# Schema version: 20110608195226
#
# Table name: votes
#
#  id         :integer         not null, primary key
#  voter_id   :integer
#  voted_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Vote < ActiveRecord::Base
    attr_accessible :voted_id
    
    belongs_to :voter, :class_name => "User"
    belongs_to :voted, :class_name => "Book"
    
    
end
